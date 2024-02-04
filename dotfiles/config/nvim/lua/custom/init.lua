require "custom.commands"
require "custom.autocmds"

vim.opt.termguicolors = true
vim.opt.title = true
vim.g.dap_virtual_text = true

vim.cmd("aunmenu PopUp.How-to\\ disable\\ mouse")
vim.cmd("aunmenu PopUp.-1-")

-- Copy
vim.api.nvim_set_keymap('n', '<YourEscapeSequenceForCmdC>', '"+y', {
    noremap = true,
    silent = true
})
-- Paste
vim.api.nvim_set_keymap('n', '<YourEscapeSequenceForCmdV>', '"+p', {
    noremap = true,
    silent = true
})
