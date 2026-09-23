local M = {}

local function root()
	return vim.fs.root(0, { "package.json", "pyproject.toml", "setup.cfg", ".git" }) or vim.fn.getcwd()
end

function M.python(project_root)
	-- A background test run for another project must not inherit this buffer's venv.
	local current_project = type(project_root) ~= "string" or project_root == root()
	local selector = package.loaded["venv-selector"]
	local selected = current_project and selector and selector.python()
	if selected and vim.fn.executable(selected) == 1 then
		return selected
	end
	-- DAP can pass a configuration table; Neotest passes the test project root.
	local directory = type(project_root) == "string" and project_root or root()
	for _, env in ipairs({ current_project and vim.env.VIRTUAL_ENV or "", directory .. "/.venv", directory .. "/venv" }) do
		if env ~= "" and vim.fn.executable(env .. "/bin/python") == 1 then
			return env .. "/bin/python"
		end
	end
	return vim.fn.exepath("python3")
end

function M.setup()
	local dap = require("dap")
	-- Mason's launcher runs the official standalone vscode-js-debug DAP server.
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = { command = "js-debug-adapter", args = { "${port}", "127.0.0.1" } },
	}
	-- VS Code launch.json commonly uses `node` as the adapter type.
	dap.adapters.node = dap.adapters["pwa-node"]
	for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
		dap.configurations[ft] = {
			{
				name = "Node: launch current file",
				type = "pwa-node",
				request = "launch",
				program = "${file}",
				cwd = root,
				runtimeExecutable = "node",
				sourceMaps = true,
				console = "integratedTerminal",
				skipFiles = { "<node_internals>/**" },
			},
			{
				name = "Node: attach to process",
				type = "pwa-node",
				request = "attach",
				processId = require("dap.utils").pick_process,
				cwd = root,
				sourceMaps = true,
				skipFiles = { "<node_internals>/**" },
			},
			{
				name = "Node: attach to inspector (9229)",
				type = "pwa-node",
				request = "attach",
				address = "127.0.0.1",
				port = 9229,
				cwd = root,
				sourceMaps = true,
				skipFiles = { "<node_internals>/**" },
			},
		}
	end
	-- Direct TS launch needs a Node version supporting type stripping. Framework
	-- apps/TSX should use their own dev command with --inspect, then attach.
	-- Custom runtimes and build output mappings belong in .vscode/launch.json.
	dap.adapters.python = { type = "executable", command = "debugpy-adapter" }
	dap.configurations.python = {
		{
			name = "Python: launch current file",
			type = "python",
			request = "launch",
			program = "${file}",
			cwd = root,
			pythonPath = M.python,
			console = "integratedTerminal",
		},
		{
			name = "Python: launch module",
			type = "python",
			request = "launch",
			module = function()
				return vim.fn.input("Python module: ")
			end,
			cwd = root,
			pythonPath = M.python,
			console = "integratedTerminal",
		},
	}
	local vscode = require("dap.ext.vscode")
	vscode.type_to_filetypes["pwa-node"] = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
	vscode.type_to_filetypes.node = vscode.type_to_filetypes["pwa-node"]
end

return M
