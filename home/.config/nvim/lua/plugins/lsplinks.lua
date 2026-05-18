return {
	"icholy/lsplinks.nvim",
	config = function()
		local lsplinks = require("lsplinks")
		lsplinks.setup({
			highlight = true,
			hl_group = "Underlined",
		})
		vim.keymap.set("n", "gx", lsplinks.gx)
	end,
}
