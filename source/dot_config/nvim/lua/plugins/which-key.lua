return { -- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Show cheatsheet",
		},
	},
	---@class wk.Opts
	opts = {
		notify = true,
		icons = {
			-- set icon mappings to true if you have a Nerd Font
			mappings = vim.g.have_nerd_font,
			-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
			-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
			keys = vim.g.have_nerd_font and {} or {
				Up = "<Up> ",
				Down = "<Down> ",
				Left = "<Left> ",
				Right = "<Right> ",
				C = "<C-…> ",
				M = "<M-…> ",
				D = "<D-…> ",
				S = "<S-…> ",
				CR = "<CR> ",
				Esc = "<Esc> ",
				ScrollWheelDown = "<ScrollWheelDown> ",
				ScrollWheelUp = "<ScrollWheelUp> ",
				NL = "<NL> ",
				BS = "<BS> ",
				Space = "<Space> ",
				Tab = "<Tab> ",
				F1 = "<F1>",
				F2 = "<F2>",
				F3 = "<F3>",
				F4 = "<F4>",
				F5 = "<F5>",
				F6 = "<F6>",
				F7 = "<F7>",
				F8 = "<F8>",
				F9 = "<F9>",
				F10 = "<F10>",
				F11 = "<F11>",
				F12 = "<F12>",
			},
		},
		plugins = {
			marks = true, -- shows a list of your marks on ' and `
			registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
			-- the presets plugin, adds help for a bunch of default keybindings in Neovim
			-- No actual key bindings are created
			spelling = {
				enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
				suggestions = 20, -- how many suggestions should be shown in the list?
			},
			presets = {
				operators = true, -- adds help for operators like d, y, ...
				motions = true, -- adds help for motions
				text_objects = true, -- help for text objects triggered after entering an operator
				windows = true, -- default bindings on <c-w>
				nav = true, -- misc bindings to work with windows
				z = true, -- bindings for folds, spelling and others prefixed with z
				g = true, -- bindings for prefixed with g
			},
		},
		-- Document existing key chains and Mini text objects without replacing mappings.
		spec = {
			{ "af", desc = "Around [f]unction", mode = { "o", "x" } },
			{ "if", desc = "Inside [f]unction", mode = { "o", "x" } },
			{ "aa", desc = "Around [a]rgument", mode = { "o", "x" } },
			{ "ia", desc = "Inside [a]rgument", mode = { "o", "x" } },
			{ "<leader>c", group = "[c]ode", mode = { "n", "x" } },
			{ "<leader>d", group = "[d]ebug" },
			{ "<leader>x", group = "Diagnostics" },
			{ "<leader>s", group = "[s]earch" },
			{ "<leader>t", group = "[t]oggle" },
			{ "<leader>h", group = "Git [h]unk", mode = { "n", "x" } },
		},
		win = {
			border = "rounded", -- Options: "single", "double", "rounded", "solid", "none"
		},
	},
}
