return {
	-- {
	-- 	"numToStr/Comment.nvim",
	-- 	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	-- 	opts = {
	-- 		pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
	-- 	},
	-- },
	{
		"echasnovski/mini.comment",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		event = "VeryLazy",
		opts = {
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		},
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = {
			enable_autocmd = false,
		},
	},
}
