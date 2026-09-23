return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"mfussenegger/nvim-dap",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
		"nvim-neotest/neotest-python",
	},
	keys = {
		{
			"<leader>rn",
			function()
				require("neotest").run.run()
			end,
			desc = "Run [n]earest test",
		},
		{
			"<leader>rf",
			function()
				require("neotest").run.run(vim.api.nvim_buf_get_name(0))
			end,
			desc = "Run test [f]ile",
		},
		{
			"<leader>rd",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Test [d]ebug",
		},
		{
			"<leader>rl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run [l]ast test",
		},
		{
			"<leader>rs",
			function()
				require("neotest").run.stop()
			end,
			desc = "Test [s]top",
		},
		{
			"<leader>ro",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "Test [o]utput",
		},
		{
			"<leader>rS",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Test [S]ummary",
		},
	},
	opts = function()
		return {
			-- Discover the files we open; avoid scanning an entire monorepo at load.
			discovery = { enabled = false },
			adapters = require("config.tests").adapters(),
		}
	end,
}
