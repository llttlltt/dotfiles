return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	lazy = false,
	config = function()
		require("hardtime").setup({
			disable_mouse = false,
			-- Teach efficient motions without blocking native navigation.
			restriction_mode = "hint",
			disabled_keys = {
				["<Up>"] = false,
				["<Down>"] = false,
				["<Left>"] = false,
				["<Right>"] = false,
			},
			max_count = 50,
			max_time = 500,
			timeout = 500,
		})
	end,
}
