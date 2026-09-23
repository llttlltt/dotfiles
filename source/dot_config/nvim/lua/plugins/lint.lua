return {

	{ -- Linting
		"mfussenegger/nvim-lint",
		ft = "markdown",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				markdown = { "markdownlint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.bo.buftype == "" and vim.bo.filetype == "markdown" and vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
			-- The first BufEnter may already have fired when lazy-loaded.
			if vim.bo.buftype == "" and vim.bo.filetype == "markdown" and vim.bo.modifiable then
				lint.try_lint()
			end
		end,
	},
}
