return {
	-- Add indentation guides even on blank lines
	"lukas-reineke/indent-blankline.nvim",
	-- See `:help ibl`
	main = "ibl",
	config = function()
		-- These are the highlight group names IBL will use for rainbow.
		-- They MUST match the names your theme *might* provide.
		local rainbow_highlight_groups = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}

		-- theme.lua owns the colours; these links are fallbacks for other themes.
		local fallback_groups = {
			"DiagnosticError",
			"DiagnosticWarn",
			"Function",
			"Constant",
			"String",
			"Statement",
			"Type",
		}

		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.ACTIVE, function(buf)
			return not require("config.largefile").is_large(buf)
		end)

		-- Reapply only missing groups when the colourscheme changes.
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			for i, hl_name in ipairs(rainbow_highlight_groups) do
				vim.api.nvim_set_hl(0, hl_name, { default = true, link = fallback_groups[i] })
			end
		end)

		vim.g.rainbow_delimiters = { highlight = rainbow_highlight_groups }

		---@module "ibl"
		---@type ibl.config
		require("ibl").setup({
			indent = {
				char = "│",
				tab_char = "│",
			},
			whitespace = {},
			scope = {
				highlight = rainbow_highlight_groups,
			},
		})

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
