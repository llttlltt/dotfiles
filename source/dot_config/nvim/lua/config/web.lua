local M = {}

local function read_json(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	local ok, data = pcall(vim.json.decode, content)
	return ok and type(data) == "table" and data or nil
end

local function ancestors(path)
	local dir = vim.fs.dirname(path)
	return function()
		local current = dir
		if current then
			local parent = vim.fs.dirname(current)
			dir = parent ~= current and parent or nil
		end
		return current
	end
end

-- Resolve from the buffer, rather than Neovim's cwd (including nested packages).
function M.package_dir(path, name)
	for dir in ancestors(path) do
		local candidate = vim.fs.joinpath(dir, "node_modules", name)
		if vim.uv.fs_stat(candidate .. "/package.json") then
			return candidate, dir
		end
	end
end

function M.typescript(path)
	local package, root = M.package_dir(path, "typescript")
	local data = package and read_json(package .. "/package.json")
	local major = data and tonumber((data.version or ""):match("^(%d+)"))
	return major, package, root
end

local function project_root(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	local major, _, ts_root = M.typescript(path)
	local _, effect_root = M.package_dir(path, "@effect/tsgo")
	if major and major >= 7 and effect_root and #effect_root > #ts_root then
		ts_root = effect_root
	end
	local root = ts_root or vim.fs.root(bufnr, { "package.json", "tsconfig.json", "jsconfig.json", ".git" })
	local deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock" })
	if deno and (not root or #deno >= #root) then
		return nil
	end
	return root or vim.fn.getcwd()
end

function M.legacy_sdk(path)
	local major, package = M.typescript(path)
	if major and major < 7 then
		return package .. "/lib"
	end
	-- Framework language tools still use the JS compiler API, absent in TS 7.
	return vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib"
end

function M.tailwind_root(bufnr, on_dir)
	local path = vim.api.nvim_buf_get_name(bufnr)
	for dir in ancestors(path) do
		for _, filename in ipairs({
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
		}) do
			if vim.uv.fs_stat(dir .. "/" .. filename) then
				return on_dir(dir)
			end
		end
		local pkg = read_json(dir .. "/package.json") or {}
		for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies" }) do
			if pkg[field] and pkg[field].tailwindcss then
				return on_dir(dir)
			end
		end
	end
end

local native_commands = {}
local pending_native = {}

-- Resolve before calling root_dir's continuation: Neovim need not block while
-- Effect selects its versioned binary. Concurrent buffer opens share the lookup.
function M.resolve_native(root, callback)
	local effect = root .. "/node_modules/.bin/effect-tsgo"
	if vim.fn.executable(effect) ~= 1 then
		native_commands[root] = root .. "/node_modules/.bin/tsc"
		callback(native_commands[root])
		return
	end
	if pending_native[root] then
		table.insert(pending_native[root], callback)
		return
	end
	pending_native[root] = { callback }
	local function finish(result)
		local executable = vim.trim(result.stdout or "")
		local callbacks = pending_native[root]
		pending_native[root] = nil
		if result.code ~= 0 or vim.fn.executable(executable) ~= 1 then
			native_commands[root] = nil
			vim.notify("Cannot resolve the project Effect TypeScript server: " .. (result.stderr or "invalid executable"), vim.log.levels.ERROR)
			return
		end
		native_commands[root] = executable
		for _, done in ipairs(callbacks) do
			done(executable)
		end
	end
	local ok, err = pcall(vim.system, { effect, "get-exe-path" }, { cwd = root, text = true, timeout = 10000 }, vim.schedule_wrap(finish))
	if not ok then
		finish({ code = -1, stderr = tostring(err) })
	end
end

function M.servers()
	return {
		ts_ls = {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			root_dir = function(bufnr, on_dir)
				local major = M.typescript(vim.api.nvim_buf_get_name(bufnr))
				local root = project_root(bufnr)
				if root and (not major or major < 7 or vim.bo[bufnr].filetype == "vue") then
					on_dir(root)
				end
			end,
			before_init = function(_, config)
				config.init_options = config.init_options or {}
				config.init_options.tsserver = { path = M.legacy_sdk(config.root_dir .. "/package.json") }
			end,
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
						languages = { "vue" },
						configNamespace = "typescript",
					},
				},
			},
		},
		tsc = {
			root_dir = function(bufnr, on_dir)
				local major = M.typescript(vim.api.nvim_buf_get_name(bufnr))
				local root = project_root(bufnr)
				if
					major
					and major >= 7
					and root
					and (vim.fn.executable(root .. "/node_modules/.bin/tsc") == 1 or vim.fn.executable(root .. "/node_modules/.bin/effect-tsgo") == 1)
				then
					local path = vim.api.nvim_buf_get_name(bufnr)
					-- An attached server already owns this root and executable.
					for _, client in ipairs(vim.lsp.get_clients({ name = "tsc" })) do
						if client.config.root_dir == root then
							on_dir(root)
							return
						end
					end
					M.resolve_native(root, function()
						if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) == path then
							on_dir(root)
						end
					end)
				end
			end,
			cmd = function(dispatchers, config)
				return vim.lsp.rpc.start({
					assert(native_commands[config.root_dir], "Native TypeScript command has not been resolved"),
					"--lsp",
					"--stdio",
				}, dispatchers, { cwd = config.root_dir })
			end,
		},
		biome = {}, -- Upstream only attaches in projects with Biome configuration.
		eslint = { settings = { format = false } }, -- Upstream checks for ESLint configuration.
		tailwindcss = { root_dir = M.tailwind_root },
		vue_ls = {},
		svelte = {},
		astro = {
			before_init = function(_, config)
				config.init_options = config.init_options or {}
				config.init_options.typescript = { tsdk = M.legacy_sdk(config.root_dir .. "/package.json") }
			end,
		},
	}
end

-- Match Prettier's documented configuration names (also used by Conform).
local prettier_configs = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.toml",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.mjs",
	".prettierrc.ts",
	".prettierrc.cts",
	".prettierrc.mts",
	"prettier.config.js",
	"prettier.config.cjs",
	"prettier.config.mjs",
	"prettier.config.ts",
	"prettier.config.cts",
	"prettier.config.mts",
}
local web_formatters = {
	javascript = "biome",
	javascriptreact = "biome",
	typescript = "biome",
	typescriptreact = "biome",
	json = "biome",
	jsonc = "biome",
	css = "biome",
	vue = "prettier",
	astro = "prettier",
	svelte = "prettier",
	scss = "prettier",
	less = "prettier",
	html = "prettier",
	yaml = "prettier",
	markdown = "prettier",
	["markdown.mdx"] = "prettier",
}

function M.is_web_buffer(bufnr)
	return web_formatters[vim.bo[bufnr].filetype] ~= nil
end

-- The nearest applicable config wins; Biome wins ties for supported filetypes.
-- Stop at the repository boundary so a home-directory config cannot override its defaults.
function M.formatter(bufnr)
	local default = web_formatters[vim.bo[bufnr].filetype]
	if not default then
		return nil
	end
	for dir in ancestors(vim.api.nvim_buf_get_name(bufnr)) do
		if default == "biome" and (vim.uv.fs_stat(dir .. "/biome.json") or vim.uv.fs_stat(dir .. "/biome.jsonc")) then
			return "biome"
		end
		local pkg = read_json(dir .. "/package.json")
		if pkg and pkg.prettier ~= nil and pkg.prettier ~= vim.NIL then
			return "prettier"
		end
		for _, name in ipairs(prettier_configs) do
			if vim.uv.fs_stat(dir .. "/" .. name) then
				return "prettier"
			end
		end
		if vim.uv.fs_stat(dir .. "/.git") then
			break
		end
	end
	return default
end

function M.formatters(bufnr)
	local name = M.formatter(bufnr)
	return name and { name } or {}
end

function M.prettier_plugins(_, ctx)
	local name = ({ astro = "prettier-plugin-astro", svelte = "prettier-plugin-svelte" })[vim.bo[ctx.buf].filetype]
	if not name then
		return {}
	end
	local dir = M.package_dir(ctx.filename, name)
	if not dir then
		return {} -- Prettier reports missing project plugins instead of installing them globally.
	end
	local pkg = read_json(dir .. "/package.json")
	local entry = pkg and (pkg.module or pkg.main)
	return entry and { "--plugin", vim.fs.joinpath(dir, entry) } or {}
end

return M
