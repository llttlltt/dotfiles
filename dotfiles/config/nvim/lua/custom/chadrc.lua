---@type ChadrcConfig 
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = 'catppuccin',
  transparency = true,

  hl_override = highlights.override,
  hl_add = highlights.add,

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "atom",
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored"
  },

  telescope = {
    style = "borderless"
  },

  statusline = {
    theme = "vscode",
    separator_style = "default"
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"
return M
