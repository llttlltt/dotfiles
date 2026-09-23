return {
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",

		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"c",
				"diff",
				"html",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"tsx",
				"css",
				"astro",
				"vue",
				"svelte",
				"rust",
				"go",
				"python",
				"json",
				"yaml",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
				callback = function(event)
					if require("config.largefile").is_large(event.buf) then
						-- Built-in ftplugins can start Treesitter before this callback.
						vim.treesitter.stop(event.buf)
						return
					end
					-- Some filetypes have no installed parser.
					if not pcall(vim.treesitter.start, event.buf) then
						return
					end

					if vim.bo[event.buf].filetype ~= "ruby" then
						vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			on_attach = function(buf)
				return not require("config.largefile").is_large(buf)
			end,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {},
	},
}
