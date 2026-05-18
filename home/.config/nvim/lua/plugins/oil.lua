return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {

		columns = {
			"icon",
			-- "permissions",
			-- "size",
			-- "mtime",
		},
		delete_to_trash = true,
		win_options = {
			signcolumn = "yes:2",
		},
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = {
		{
			"echasnovski/mini.icons",
			opts = {},
		},
	},
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
}
