local overrides = require "custom.configs.overrides"
local cmp = require "cmp"

local plugins = { ----- default plugins -----
{
    "hrsh7th/nvim-cmp",
    opts = function()
        local M = require "plugins.configs.cmp"
        M.completion.completeopt = "menu,menuone,noselect"
        M.mapping["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = false
        }
        table.insert(M.sources, {
            name = "crates"
        })
        return M
    end
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require "plugins.configs.lspconfig"
        require "custom.configs.lspconfig"
    end
}, -- eslint
{
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
        require "custom.configs.lint"
    end
}, -- prettier
{
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    opts = function()
        return require "custom.configs.formatter"
    end
}, -- override default configs
{
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree
}, {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter
}, {
    "williamboman/mason.nvim",
    opts = overrides.mason
}, {
    "hrsh7th/nvim-cmp",
    opts = overrides.nvimcmp
}, ----- custom plugins -----
{
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
        vim.g.rustfmt_autosave = 1
    end
}, {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function()
        return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
        require('rust-tools').setup(opts)
    end
}, {
    "mfussenegger/nvim-dap",
    init = function()
        require("core.utils").load_mappings("dap")
    end,
    config = function()
        require('dap')
    end
}, {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    dependencies = "mfussenegger/nvim-dap",
    config = function(_)
        require("nvim-dap-virtual-text").setup()
    end
}, {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function(_, opts)
        local crates = require('crates')
        crates.setup(opts)
        require('cmp').setup.buffer({
            sources = {{
                name = "crates"
            }}
        })
        crates.show()
        require("core.utils").load_mappings("crates")
    end
}, {
    "p00f/nvim-ts-rainbow",
    dependencies = "nvim-treesitter/nvim-treesitter"
}, {
    "karb94/neoscroll.nvim",
    keys = {"<C-d>", "<C-u>"},
    config = function()
        require("neoscroll").setup()
    end
}, -- autoclose tags in html, jsx only
{
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
        require("nvim-ts-autotag").setup()
    end
}, -- get highlight group under cursor
{
    "nvim-treesitter/playground",
    cmd = "TSCaptureUnderCursor",
    config = function()
        require("nvim-treesitter.configs").setup()
    end
}, -- dim inactive windows
{
    "andreadev-it/shade.nvim",
    keys = "<Bslash>",
    config = function()
        require("shade").setup {
            exclude_filetypes = {"NvimTree"}
        }
    end
}, {
    "folke/trouble.nvim",
    cmd = "Trouble",
    config = function()
        require("trouble").setup()
    end
}, {
    "christoomey/vim-tmux-navigator",
    lazy = false
}}
return plugins
