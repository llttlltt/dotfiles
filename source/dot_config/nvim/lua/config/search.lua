local M = {}

local function directory()
	local name = vim.api.nvim_buf_get_name(0)
	-- File explorers, terminals and unnamed buffers use the current directory.
	if name == "" or vim.bo.buftype ~= "" then
		return vim.fn.getcwd()
	end
	return vim.fs.dirname(name)
end

function M.root(package_scope)
	local dir = directory()
	local repo = vim.fs.root(dir, ".git")
	if package_scope or not repo then
		local current = dir
		while current do
			for _, marker in ipairs({ "package.json", "pyproject.toml", "setup.cfg", "go.mod", "Cargo.toml" }) do
				if vim.uv.fs_stat(current .. "/" .. marker) then
					return current
				end
			end
			if current == repo then
				break
			end
			local parent = vim.fs.dirname(current)
			current = parent ~= current and parent or nil
		end
	end
	return repo or dir
end

function M.pick(picker, package_scope)
	return function()
		require("telescope.builtin")[picker]({ cwd = M.root(package_scope) })
	end
end

return M
