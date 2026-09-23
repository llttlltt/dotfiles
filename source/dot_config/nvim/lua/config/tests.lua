local M = {}

local function javascript(adapter, runner)
	local is_test_file = adapter.is_test_file
	adapter.is_test_file = function(path)
		if not path then
			return false
		end
		-- Upstream can fall back to dependencies from Neovim's cwd. Only allow
		-- runners declared in the test file's own package/ancestor workspace.
		local dir = vim.fs.dirname(path)
		while dir do
			local file = io.open(dir .. "/package.json", "r")
			if file then
				local content = file:read("*a")
				file:close()
				local ok, pkg = pcall(vim.json.decode, content)
				if ok and type(pkg) == "table" then
					local deps = vim.tbl_extend("force", pkg.dependencies or {}, pkg.devDependencies or {})
					if deps.vitest or deps.jest then
						return deps[runner] ~= nil and is_test_file(path)
					end
				end
			end
			if vim.uv.fs_stat(dir .. "/.git") then
				break
			end
			local parent = vim.fs.dirname(dir)
			dir = parent ~= dir and parent or nil
		end
		return false
	end
	local build_spec = adapter.build_spec
	adapter.build_spec = function(args)
		local path = args.tree:data().path
		local package, root = require("config.web").package_dir(path, runner)
		local binary = root and (root .. "/node_modules/.bin/" .. runner)
		assert(binary and vim.fn.executable(binary) == 1, "Install " .. runner .. " in the test project first")
		-- These adapters split command strings on whitespace. Resolve the local
		-- executable separately so Dropbox paths containing spaces remain one argv.
		args = vim.tbl_extend("force", {}, args, { [runner .. "Command"] = runner })
		local spec = build_spec(args)
		spec.command[1] = binary
		if args.strategy == "dap" then
			-- pnpm's .bin entries are shell scripts; Node needs the JS entrypoint.
			local file = assert(io.open(package .. "/package.json", "r"))
			local content = file:read("*a")
			file:close()
			local manifest = vim.json.decode(content)
			local entry = type(manifest.bin) == "table" and manifest.bin[runner] or manifest.bin
			assert(type(entry) == "string", "Missing " .. runner .. " JavaScript entrypoint")
			spec.strategy.runtimeExecutable = "node"
			spec.strategy.program = assert(vim.uv.fs_realpath(vim.fs.joinpath(package, entry)))
		end
		return spec
	end
	return adapter
end

function M.adapters()
	local python = require("neotest-python")({ python = require("config.debug").python })
	local build_python = python.build_spec
	python.build_spec = function(args)
		local spec = build_python(args)
		local root = python.root(args.tree:data().path)
		spec.cwd = root
		if args.strategy == "dap" then
			spec.strategy.cwd = root
		end
		return spec
	end
	return {
		javascript(require("neotest-vitest"), "vitest"),
		javascript(
			require("neotest-jest")({
				cwd = function(path)
					return vim.fs.root(path, "package.json")
				end,
			}),
			"jest"
		),
		python,
	}
end

return M
