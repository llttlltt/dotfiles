-- overriding default plugin configs!
local M = {}

M.treesitter = {
  ensure_installed = { --
  "vim", "lua", -- defaults
  "html", "css", "javascript", "typescript", "tsx", "json" -- web
  },

  highlight = {
    enable = true
  },

  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil
  }
}

M.nvimtree = {
  filters = {
    dotfiles = true,
    custom = {"node_modules"}
  },

  git = {
    enable = true
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true
      }
    }
  }
}

M.mason = {
  ensure_installed = { --
  "lua-language-server", "stylua", -- lua
  "taplo", "yaml-language-server", "yamllint", -- config files
  "shfmt", ":shellcheck", "bash-language-server", -- shell
  "html-lsp", "tsfmt", "typescript-language-server", -- web
  "tailwindcss-language-server", "css-lsp", -- styling
  "json-lsp", -- data
  "prettier", "eslint_lsp" -- prettier | eslint
  }
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
      }
    }
  end
}

return M
