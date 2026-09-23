local M = {}

-- Keep expensive visuals out of generated bundles and large data files.
function M.is_large(bufnr)
	bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end
	local lines = vim.api.nvim_buf_line_count(bufnr)
	if lines > 10000 then
		return true
	end
	if vim.api.nvim_buf_is_loaded(bufnr) then
		local bytes = vim.api.nvim_buf_get_offset(bufnr, lines)
		if bytes > 1024 * 1024 then
			return true
		end
	end
	local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(bufnr))
	return stat ~= nil and stat.size > 1024 * 1024
end

return M
