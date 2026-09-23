-- Adds git related signs to the gutter, as well as utilities for managing changes

return {
	-- Here is a more advanced example where we pass configuration
	-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
	--    require('gitsigns').setup({ ... })
	--
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},

			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						gitsigns.nav_hunk("next")
					end
				end, { desc = "Next Git [c]hange" })

				map("n", "[c", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						gitsigns.nav_hunk("prev")
					end
				end, { desc = "Previous Git [c]hange" })

				-- Actions
				-- visual mode
				map("x", "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Hunk [s]tage" })
				map("x", "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Hunk [r]eset" })
				-- normal mode
				map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Hunk [s]tage" })
				map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Hunk [r]eset" })
				map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })
				map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })
				map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Hunk [p]review" })
				map("n", "<leader>hb", gitsigns.blame_line, { desc = "Line [b]lame" })
				map("n", "<leader>hd", gitsigns.diffthis, { desc = "Index [d]iff" })
				map("n", "<leader>hD", function()
					gitsigns.diffthis("@")
				end, { desc = "Last-commit [D]iff" })
				-- Toggles
				map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Git line [b]lame" })
			end,
		},
	},
}
