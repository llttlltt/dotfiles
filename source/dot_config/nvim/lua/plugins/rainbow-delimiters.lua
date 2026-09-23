return {
	"HiPhish/rainbow-delimiters.nvim",
	config = function()
		require("rainbow-delimiters.setup").setup({
			condition = function(buf)
				return not require("config.largefile").is_large(buf)
			end,
		})
	end,
}
