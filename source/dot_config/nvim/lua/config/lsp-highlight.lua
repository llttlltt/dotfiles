local M = {}
local group = vim.api.nvim_create_augroup("UserLspHighlight", { clear = true })
local method = vim.lsp.protocol.Methods.textDocument_documentHighlight

function M.attach(bufnr)
	-- Multiple servers may attach to one buffer; install its handlers just once.
	if #vim.api.nvim_get_autocmds({ group = group, buffer = bufnr }) > 0 then
		return
	end
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group,
		buffer = bufnr,
		callback = vim.lsp.buf.document_highlight,
	})
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		buffer = bufnr,
		callback = vim.lsp.buf.clear_references,
	})
end

vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("UserLspHighlightDetach", { clear = true }),
	callback = function(event)
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = event.buf })) do
			if client.id ~= event.data.client_id and client:supports_method(method, event.buf) then
				return
			end
		end
		if vim.api.nvim_buf_is_valid(event.buf) then
			vim.lsp.util.buf_clear_references(event.buf)
			vim.api.nvim_clear_autocmds({ group = group, buffer = event.buf })
		end
	end,
})

return M
