return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	lazy = false,
	config = function()
		require("hardtime").setup({
			disable_mouse = false,
			max_count = 50,
			max_time = 500,
			timeout = 500,
		})
	end,
}
