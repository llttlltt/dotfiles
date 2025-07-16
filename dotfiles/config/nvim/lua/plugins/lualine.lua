return {

	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		require("lualine").setup({
			options = {
				theme = "poimandres",
				icons_enabled = vim.g.have_nerd_font,
				section_separators = "",
				component_separators = "",
			},
		})
	end,
}
