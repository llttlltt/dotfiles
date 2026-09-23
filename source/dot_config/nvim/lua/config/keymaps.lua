-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Exit terminal mode [Esc Esc] in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics location list" })

-- Normal mode mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Search [n]ext result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Use native <C-w>h/j/k/l for window navigation; keep normal Ctrl keys unchanged.

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("x", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right and reselect" })

-- Oil
vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
