local cmp = require "cmp"

local plugins = {{
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {"rust-analyzer"}
    }
}, {
    "neovim/nvim-lspconfig",
    config = function()
        require "plugins.configs.lspconfig"
        require "custom.configs.lspconfig"
    end
}, {
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
    config = function(_, opts)
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
} -- {
--   "christoomey/vim-tmux-navigator",
--   lazy = false,
-- },
}
return plugins
