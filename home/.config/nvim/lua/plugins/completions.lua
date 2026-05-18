return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
			},
			{
				-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
				-- used for completion, annotations and signatures of Neovim apis
				"folke/lazydev.nvim",
				dependencies = { "Bilal2453/luvit-meta", lazy = true },
				ft = "lua",
				opts = {
					library = {
						-- Load luvit types when the `vim.uv` word is found
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
		},

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					auto_show = true,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
					},
				},
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1 },
						},
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				ghost_text = {
					enabled = true,
				},
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
				},
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
				},
				per_filetype = {
					lua = { inherit_defaults = true, "lazydev" },
				},
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
				sorts = {
					"score",
					"exact",
					"sort_text",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("colorful-menu").setup({
				ls = {
					lua_ls = {
						arguments_hl = "@comment",
					},
					gopls = {
						align_type_to_right = true,
						add_colon_before_type = false,
						preserve_type_when_truncate = true,
					},
					ts_ls = {
						extra_info_hl = "@comment",
					},
					vtsls = {
						extra_info_hl = "@comment",
					},
					["rust-analyzer"] = {
						extra_info_hl = "@comment",
						align_type_to_right = true,
						preserve_type_when_truncate = true,
					},
					clangd = {
						extra_info_hl = "@comment",
						align_type_to_right = true,
						import_dot_hl = "@comment",
						preserve_type_when_truncate = true,
					},
					zls = {
						align_type_to_right = true,
					},
					roslyn = {
						extra_info_hl = "@comment",
					},
					dartls = {
						extra_info_hl = "@comment",
					},
					basedpyright = {
						extra_info_hl = "@comment",
					},
					pylsp = {
						extra_info_hl = "@comment",
						arguments_hl = "@comment",
					},
					fallback = true,
					fallback_extra_info_hl = "@comment",
				},
				fallback_highlight = "@variable",
				max_width = 60,
			})
		end,
	},
}
