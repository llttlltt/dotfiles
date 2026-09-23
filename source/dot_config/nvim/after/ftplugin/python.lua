vim.keymap.set("n", "<leader>cv", "<cmd>VenvSelect<cr>", {
	buffer = true,
	desc = "Select Python [v]irtual environment",
})

local undo = "silent! nunmap <buffer> <leader>cv"
vim.b.undo_ftplugin = vim.b.undo_ftplugin and (vim.b.undo_ftplugin .. " | " .. undo) or undo
