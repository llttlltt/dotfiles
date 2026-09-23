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
			-- JSON's TextMate rules cycle key colours by enclosing object depth.
			-- Count objects, not arrays, so arrays of objects keep the same rule.
			vim.treesitter.query.add_predicate("poimandres-json-depth?", function(match, _, _, predicate)
				local nodes = match[predicate[2]]
				local node = type(nodes) == "table" and nodes[1] or nodes
				local depth = 0
				while node do
					if node:type() == "object" then
						depth = depth + 1
					end
					node = node:parent()
				end
				return (depth - 1) % 4 + 1 == tonumber(predicate[3])
			end, { force = true })
			local palette = vim.tbl_extend("force", {}, require("poimandres.palette"), {
				-- Original VS Code colours absent from the Neovim port's palette.
				magenta = "#f087bd",
				selection = "#717cb4",
				black = "#000000",
			})
			-- Reference: drcmda/poimandres-theme, themes/poimandres-color-theme.json.
			-- VS Code alpha colours are approximated against its #1b1e28 background.
			-- Transparent terminal backgrounds can therefore look slightly different.
			local blend = require("poimandres.utils").blend
			local widget_border = blend(palette.white, palette.background2, 0x10 / 255)
			local selection = blend(palette.selection, palette.background2, 0x25 / 255)
			local search = blend(palette.blue2, palette.background2, 0x40 / 255)
			local hint = blend(palette.blue4, palette.background2, 0xB3 / 255)
			require("poimandres").setup({
				bold_vert_split = false, -- use bold vertical separators
				-- Inactive-window dimming requires an opaque background; keep transparency.
				disable_background = true, -- disable background
				disable_float_background = true, -- disable background for floats
				disable_italics = false, -- disable italics
				-- Diagnostic families are generated from these colours by Poimandres.
				groups = { info = palette.blue2, hint = hint },
				highlight_groups = {
					-- Editor chrome: editor.foreground, line numbers, cursor and current line.
					Normal = { fg = palette.blueGray1 },
					NormalNC = { fg = palette.blueGray1 },
					NormalFloat = { fg = palette.blueGray1 },
					Cursor = { fg = palette.background2, bg = palette.blueGray1 },
					CursorLine = { bg = selection },
					CursorLineNr = { fg = palette.blueGray1 },
					LineNr = { fg = blend(palette.blueGray2, palette.background2, 0x50 / 255) },
					-- Search: Neovim cannot draw VS Code's find-match border.
					Search = { bg = search },
					IncSearch = { bg = search, sp = palette.blue2, style = "underline" },
					CurSearch = { link = "IncSearch" },
					-- Diff: upstream inserted/removed text backgrounds.
					-- Neovim distinguishes changed lines and words; reuse the added-text tint.
					DiffAdd = { bg = blend(palette.blueGray3, palette.background2, 0x15 / 255) },
					DiffDelete = { bg = blend(palette.pink3, palette.background2, 0x20 / 255) },
					DiffChange = { bg = blend(palette.blueGray3, palette.background2, 0x15 / 255) },
					DiffText = { bg = blend(palette.blueGray3, palette.background2, 0x15 / 255), style = "underline" },
					-- Editor selections and references: VS Code selection/wordHighlight colours.
					Visual = { bg = selection },
					LspReferenceText = { bg = blend(palette.blue2, palette.background2, 0x20 / 255) },
					LspReferenceRead = { bg = blend(palette.blue2, palette.background2, 0x20 / 255) },
					LspReferenceWrite = { bg = blend(palette.blue2, palette.background2, 0x40 / 255) },
					-- Syntax: closest Treesitter equivalents to the upstream TextMate rules.
					Function = { fg = palette.blue2 },
					Keyword = { fg = palette.blueGray1 },
					Operator = { fg = palette.blue3 },
					Exception = { fg = palette.pink3 },
					Character = { fg = palette.teal1 },
					["@keyword.exception"] = { link = "Exception" },
					["@keyword.operator"] = { link = "Operator" },
					["@keyword.function"] = { fg = palette.blue3 },
					["@keyword.modifier"] = { fg = palette.teal1 },
					["@property"] = { fg = palette.text },
					Comment = { fg = blend(palette.blueGray2, palette.background2, 0xB0 / 255), style = "italic" },
					["@function.call"] = { fg = blend(palette.text, palette.background2, 0xD0 / 255) },
					["@constructor"] = { fg = palette.blue2 },
					["@string.escape"] = { fg = palette.teal2 },
					["@string.regexp"] = { fg = palette.teal2 },
					["@keyword.import"] = { fg = palette.teal1 },
					["@keyword.return"] = { fg = blend(palette.teal1, palette.background2, 0xC0 / 255) },
					["@punctuation.delimiter"] = { fg = palette.blueGray1 },
					["@punctuation.bracket"] = { fg = palette.blueGray1 },
					-- colorcolumn
					ColorColumn = { link = "CursorColumn" },
					-- Treesitter: current capture names missing from the upstream theme.
					["@function.method"] = { fg = palette.blue2 },
					["@function.method.call"] = { link = "@function.call" },

					["@variable.parameter"] = { fg = palette.text },
					["@variable.member"] = { fg = palette.text },
					["@module"] = { fg = palette.text },
					-- JS/TS: queries distinguish falsy literals from true and other builtins.
					["@poimandres.falsy"] = { fg = palette.pink3 },
					["@poimandres.self"] = { fg = palette.teal1 },
					-- JSON keys: white, blue, muted blue, then darker blue, repeating.
					["@poimandres.json.key.1"] = { fg = palette.text },
					["@poimandres.json.key.2"] = { fg = palette.blue2 },
					["@poimandres.json.key.3"] = { fg = palette.blue3 },
					["@poimandres.json.key.4"] = { fg = palette.blue4 },
					-- Language-specific property/attribute rules from the original theme.
					["@property.css"] = { fg = palette.blue2 },
					["@attribute.css"] = { fg = palette.teal2 },
					["@tag.attribute.html"] = { fg = palette.teal2, style = "italic" },
					-- Let Treesitter distinguish JS/TS declarations from calls.
					-- Only these semantic token colours are cleared; LSP features stay enabled.
					["@lsp.type.function.javascript"] = {},
					["@lsp.type.function.javascriptreact"] = {},
					["@lsp.type.function.typescript"] = {},
					["@lsp.type.function.typescriptreact"] = {},
					["@lsp.type.method.javascript"] = {},
					["@lsp.type.method.javascriptreact"] = {},
					["@lsp.type.method.typescript"] = {},
					["@lsp.type.method.typescriptreact"] = {},
					-- Semantic class tokens otherwise inherit the generic type colour.
					["@lsp.type.class"] = { link = "@constructor" },
					["@markup.strong"] = { fg = palette.blue4, style = "bold" },
					["@markup.italic"] = { fg = palette.blue4, style = "italic" },
					-- Upstream markup.strike uses italics rather than a strike line.
					["@markup.strikethrough"] = { style = "italic" },
					["@markup.underline"] = { fg = palette.blue4, style = "underline" },
					["@markup.heading"] = { fg = palette.text, style = "bold" },
					["@markup.heading.1"] = { fg = palette.text, style = "bold" },
					["@markup.heading.2"] = { fg = palette.text, style = "bold" },
					["@markup.heading.3"] = { fg = palette.text, style = "bold" },
					["@markup.heading.4"] = { fg = palette.text, style = "bold" },
					["@markup.heading.5"] = { fg = palette.text, style = "bold" },
					["@markup.heading.6"] = { fg = palette.text, style = "bold" },
					["@markup.link"] = { fg = palette.teal1 },
					["@markup.link.url"] = { fg = palette.blue2, style = "underline" },
					["@markup.raw"] = { fg = palette.blue2 },
					["@markup.list"] = { fg = palette.blue2 },
					-- nvim-navic: upstream breadcrumb.* and symbolIcon.*Foreground colours.
					WinBar = { fg = blend(palette.blueGray2, palette.background2, 0xCC / 255) },
					WinBarNC = { link = "WinBar" },
					NavicIconsFile = { fg = palette.blueGray1 },
					NavicIconsModule = { fg = palette.blueGray1 },
					NavicIconsNamespace = { fg = palette.blueGray1 },
					NavicIconsPackage = { fg = palette.blueGray1 },
					NavicIconsClass = { fg = palette.yellow },
					NavicIconsMethod = { fg = palette.magenta },
					NavicIconsProperty = { fg = palette.blueGray1 },
					NavicIconsField = { fg = palette.blue2 },
					NavicIconsConstructor = { fg = palette.magenta },
					NavicIconsEnum = { fg = palette.yellow },
					NavicIconsInterface = { fg = palette.blue2 },
					NavicIconsFunction = { fg = palette.magenta },
					NavicIconsVariable = { fg = palette.blue2 },
					NavicIconsConstant = { fg = palette.blueGray1 },
					NavicIconsString = { fg = palette.blueGray1 },
					NavicIconsNumber = { fg = palette.blueGray1 },
					NavicIconsBoolean = { fg = palette.blueGray1 },
					NavicIconsArray = { fg = palette.blueGray1 },
					NavicIconsObject = { fg = palette.blueGray1 },
					NavicIconsKey = { fg = palette.blueGray1 },
					NavicIconsNull = { fg = palette.blueGray1 },
					NavicIconsEnumMember = { fg = palette.blue2 },
					NavicIconsStruct = { fg = palette.blueGray1 },
					NavicIconsEvent = { fg = palette.yellow },
					NavicIconsOperator = { fg = palette.blueGray1 },
					NavicIconsTypeParameter = { fg = palette.blueGray1 },
					NavicText = { link = "WinBar" },
					NavicSeparator = { link = "WinBar" },
					-- which-key: use the same subtle border as upstream editor widgets.
					WhichKeyBorder = { link = "FloatBorder" },
					-- shared floating-window border
					FloatBorder = { fg = widget_border },
					-- Telescope: VS Code quickInput.*, list.* and pickerGroup.* equivalents.
					-- Keep the panel background transparent like our other floating windows.
					TelescopeNormal = { fg = palette.blueGray1 },
					TelescopePromptNormal = { fg = palette.text },
					TelescopeBorder = { fg = palette.blueGray1 },
					TelescopePromptBorder = { fg = widget_border },
					TelescopeTitle = { fg = palette.blue1 },
					TelescopePreviewTitle = { fg = palette.blue1 },
					TelescopePromptTitle = { fg = palette.blue1 },
					TelescopeMatching = { fg = palette.teal2 },
					TelescopeSelection = { fg = palette.blueGray1, bg = blend(palette.blueGray1, palette.background2, 0x10 / 255) },
					-- Git signs: editorGutter colours, blended over the original background.
					GitSignsAdd = { fg = blend(palette.teal2, palette.background2, 0x40 / 255) },
					GitSignsChange = { fg = blend(palette.blue2, palette.background2, 0x20 / 255) },
					GitSignsDelete = { fg = blend(palette.pink3, palette.background2, 0x40 / 255) },
					-- blink.cmp
					BlinkCmpMenuBorder = { link = "FloatBorder" },
					BlinkCmpDocBorder = { link = "FloatBorder" },
					BlinkCmpSignatureHelpActiveParameter = { fg = palette.text, style = "underline" },
					BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
					-- Completion labels: uniform text with highlighted fuzzy matches.
					BlinkCmpLabel = { fg = palette.blueGray1 },
					BlinkCmpLabelMatch = { fg = palette.teal1 },
					BlinkCmpDoc = { fg = palette.blueGray1 },
					BlinkCmpMenuSelection = { bg = blend(palette.black, palette.background2, 0x50 / 255) },
					-- Completion kinds: exact upstream symbolIcon.*Foreground values.
					BlinkCmpKind = { fg = palette.blueGray1 },
					BlinkCmpKindText = { fg = palette.blueGray1 },
					BlinkCmpKindMethod = { fg = palette.magenta },
					BlinkCmpKindFunction = { fg = palette.magenta },
					BlinkCmpKindConstructor = { fg = palette.magenta },
					BlinkCmpKindField = { fg = palette.blue2 },
					BlinkCmpKindVariable = { fg = palette.blue2 },
					BlinkCmpKindClass = { fg = palette.yellow },
					BlinkCmpKindInterface = { fg = palette.blue2 },
					BlinkCmpKindModule = { fg = palette.blueGray1 },
					BlinkCmpKindProperty = { fg = palette.blueGray1 },
					BlinkCmpKindUnit = { fg = palette.blueGray1 },
					BlinkCmpKindValue = { fg = palette.blueGray1 },
					BlinkCmpKindEnum = { fg = palette.yellow },
					BlinkCmpKindKeyword = { fg = palette.blueGray1 },
					BlinkCmpKindSnippet = { fg = palette.blueGray1 },
					BlinkCmpKindColor = { fg = palette.blueGray1 },
					BlinkCmpKindFile = { fg = palette.blueGray1 },
					BlinkCmpKindReference = { fg = palette.blueGray1 },
					BlinkCmpKindFolder = { fg = palette.blueGray1 },
					BlinkCmpKindEnumMember = { fg = palette.blue2 },
					BlinkCmpKindConstant = { fg = palette.blueGray1 },
					BlinkCmpKindStruct = { fg = palette.blueGray1 },
					BlinkCmpKindEvent = { fg = palette.yellow },
					BlinkCmpKindOperator = { fg = palette.blueGray1 },
					BlinkCmpKindTypeParameter = { fg = palette.blueGray1 },
					-- indent-blankline + rainbow-delimiters: custom palette-based nesting colours.
					-- Upstream does not specify a rainbow sequence; retain our visual aid.
					IblIndent = { link = "IndentBlanklineChar" },
					RainbowRed = { fg = palette.pink3 },
					RainbowYellow = { fg = palette.yellow },
					RainbowBlue = { fg = palette.blue2 },
					RainbowOrange = { fg = palette.pink2 },
					RainbowGreen = { fg = palette.teal1 },
					RainbowViolet = { fg = palette.pink1 },
					RainbowCyan = { fg = palette.blue1 },
					-- neotest: status colours and the summary panel.
					NeotestPassed = { fg = palette.teal1 },
					NeotestFailed = { link = "DiagnosticError" },
					NeotestRunning = { link = "DiagnosticWarn" },
					NeotestSkipped = { fg = palette.blue4 },
					NeotestUnknown = { fg = palette.blue4 },
					NeotestNamespace = { link = "@module" },
					NeotestFile = { link = "Directory" },
					NeotestDir = { link = "Directory" },
					NeotestIndent = { link = "Comment" },
					NeotestExpandMarker = { link = "Comment" },
					NeotestAdapterName = { link = "Title" },
					NeotestWinSelect = { fg = palette.blue1, style = "bold" },
					NeotestMarked = { fg = palette.yellow, style = "bold" },
					NeotestTarget = { fg = palette.pink3 },
					NeotestWatching = { link = "DiagnosticWarn" },
				},
			})
			-- Apply after setup so overrides also survive :colorscheme poimandres.
			vim.cmd("colorscheme poimandres")
		end,
	},
}
