return {

	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		local palette = require("poimandres.palette")
		-- VS Code statusBar.foreground, retaining our transparent background.
		-- Mode names still identify Normal/Insert/etc. without coloured blocks.
		local section = { fg = palette.blueGray1, bg = palette.none }
		local theme = {}
		for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "terminal", "inactive" }) do
			theme[mode] = { a = vim.deepcopy(section), b = vim.deepcopy(section), c = vim.deepcopy(section) }
		end
		require("lualine").setup({
			options = {
				theme = theme,
				icons_enabled = vim.g.have_nerd_font,
				section_separators = "",
				component_separators = "",
			},
		})
	end,
}
