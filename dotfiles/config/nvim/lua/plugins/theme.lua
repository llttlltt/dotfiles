-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
return {
	{
		"olivercederborg/poimandres.nvim",
		lazy = false,
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			require("poimandres").setup({
				bold_vert_split = false, -- use bold vertical separators
				dim_nc_background = true, -- dim 'non-current' window backgrounds
				disable_background = true, -- disable background
				disable_float_background = true, -- disable background for floats
				disable_italics = false, -- disable italics
				highlight_groups = {
					-- easier to read highlights
					LspReferenceText = { link = "Visual" },
					LspReferenceRead = { link = "Visual" },
					LspReferenceWrite = { link = "Visual" },
					-- colorcolumn
					ColorColumn = { link = "CursorColumn" },
					-- nvim-navic
					WinBar = { link = "Title" },
					WinBarNC = { link = "BufferInactive" },
					NavicIconsFile = { link = "CmpItemKindFile" },
					NavicIconsModule = { link = "CmpItemKindModule" },
					NavicIconsNamespace = { link = "CmpItemKind" },
					NavicIconsPackage = { link = "CmpItemKind" },
					NavicIconsClass = { link = "@constructor" },
					NavicIconsMethod = { link = "@method" },
					NavicIconsProperty = { link = "CmpItemKindProperty" },
					NavicIconsField = { link = "CmpItemKindField" },
					NavicIconsConstructor = { link = "@constructor" },
					NavicIconsEnum = { link = "CmpItemKindEnum" },
					NavicIconsInterface = { link = "CmpItemKindInterface" },
					NavicIconsFunction = { link = "CmpItemKindFunction" },
					NavicIconsVariable = { link = "CmpItemKindVariable" },
					NavicIconsConstant = { link = "@constant" },
					NavicIconsString = { link = "@string" },
					NavicIconsNumber = { link = "@number" },
					NavicIconsBoolean = { link = "@boolean" },
					NavicIconsArray = { link = "CmpItemKind" },
					NavicIconsObject = { link = "@method" },
					NavicIconsKey = { link = "CmpItemKindKeyword" },
					NavicIconsNull = { link = "CmpItemKind" },
					NavicIconsEnumMember = { link = "CmpItemKindEnumMember" },
					NavicIconsStruct = { link = "CmpItemKindStruct" },
					NavicIconsEvent = { link = "CmpItemKindEvent" },
					NavicIconsOperator = { link = "@operator" },
					NavicIconsTypeParameter = { link = "CmpItemKindTypeParameter" },
					-- NavicText = { link = "Normal" },
					NavicSeparator = { link = "StatusLine" },
					-- which-key
					WhichKeyBorder = { link = "NotifyINFOBorder" },
					-- nvim-cmp
					FloatBorder = { link = "NotifyDEBUGBorder" },
					-- blink.cmp
					BlinkCmpSignatureHelpActiveParameter = { link = "Visual" },
					BlinkCmpSignatureHelpBorder = { link = "TelescopeBorder" },
					-- BlinkCmpSignatureHelp = { link = "PmenuSel" },
				},
			})
		end,
		init = function()
			-- Load the colorscheme here.
			vim.cmd("colorscheme poimandres")
		end,
		opts = {},
	},
}
