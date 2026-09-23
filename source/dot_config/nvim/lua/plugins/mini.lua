return {
	"nvim-mini/mini.ai", -- Collection of various small independent plugins/modules
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	opts = function()
		return {
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			n_lines = 500,
			custom_textobjects = {
				-- Function definitions: yaf/yif, daf/dif, vaf/vif.
				f = require("mini.ai").gen_spec.treesitter({
					a = "@function.outer",
					i = "@function.inner",
				}),
			},
		}
	end,
}
