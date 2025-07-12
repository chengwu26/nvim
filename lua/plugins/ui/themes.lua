---@brief
---
--- This module maintains all of themes/colorscheme .
---
--- You can use `:Themery` to switch theme (select: j, k; quit: q, <ESC>).
--- Since it isn't frequent to swithch theme, so there isn't keymap to switch
--- themes.
---
--- If you want to add another colorscheme, refer the comment of 'dependencies'
--- and 'opts' keys. Remove colorscheme also just need to delete it from
--- 'dependencies' and 'opts'.

---@type LazySpec
return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- Add colorscheme's name at here to let 'Themery' to manage it.
    themes = {
      "default",
      "catppuccin-latte",
      "catppuccin-frappe",
      "catppuccin-macchiato",
      "catppuccin-mocha",
    },
  },
  -- Add colorscheme as dependence to install and load them
  dependencies = {
    { "catppuccin/nvim", name = "catppuccin" },
  },
}
