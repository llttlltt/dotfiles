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

		-- Define fallback hardcoded colors in the same order as the highlight groups
		local fallback_colors = {
			"#E06C75", -- Red
			"#E5C07B", -- Yellow
			"#61AFEF", -- Blue
			"#D19A66", -- Orange
			"#98C379", -- Green
			"#C678DD", -- Violet
			"#56B6C2", -- Cyan
		}

		local hooks = require("ibl.hooks")

		local function get_hl_attrs(name)
			local hl_id = vim.api.nvim_get_hl_id_by_name(name)
			if hl_id ~= 0 then
				local hl = vim.api.nvim_get_hl(0, { id = hl_id })
				if hl then
					return { fg = hl.fg, ctermfg = hl.ctermfg }
				end
			end
			return nil
		end

		-- Create or re-apply the highlight groups in the HIGHLIGHT_SETUP hook.
		-- This ensures they are reset and re-evaluated every time the colorscheme changes.
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			for i, hl_name in ipairs(rainbow_highlight_groups) do
				local hl_attrs = get_hl_attrs(hl_name)
				local color_found = false

				-- Check if the theme already defined this highlight group with a foreground color
				if hl_attrs and (hl_attrs.fg or hl_attrs.ctermfg) then
					color_found = true
				end

				-- If the theme didn't provide it, use our fallback
				if not color_found then
					local fallback_color = fallback_colors[i]
					if fallback_color then
						vim.api.nvim_set_hl(0, hl_name, { fg = fallback_color })
					end
				end
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
			scope = {
				highlight = rainbow_highlight_groups,
			},
		})

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}
