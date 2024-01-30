-- overriding default plugin configs!

local M = {}

M.treesitter = {
  ensure_installed = {
    -- defaults
    "vim",
    "lua",

    -- web dev
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "json",
  },

  highlight = {
    enable = true,
  },

  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

M.nvimtree = {
  filters = {
    dotfiles = true,
    custom = { "node_modules" },
  },

  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- config files
    "taplo",
    "yaml-language-server",
    "yamllint",

    -- web dev
    "tsfmt", -- for prettier
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "prettier",
    "eslint_lsp",
    "json-lsp",
    "tailwindcss-language-server",

    -- shell
    "shfmt",
    ":shellcheck",
    "bash-language-server",

  },
}

M.nvimcmp = {
  override_options = function()
    local cmp = require("cmp")

    return {
      mapping = {
        -- ["<C-p>"] = cmp.mapping.select_prev_item(),
        -- ["<C-n>"] = cmp.mapping.select_next_item(),
        -- ["<C-y>"] = cmp.mapping.select_confirm({ select = true }),
        -- ["<C-Space>"] = cmp.mapping.complete(),
      },
    }
  end,
}

return M
