--- This module maintains all of themes
--- You can use `:Themery` to switch theme(select: j, k; quit: q, <ESC>).
--- Since it's not frequent to swithch theme, so there isn't keymap.
---
--- If you want to add another colorscheme,
--- refer the comment of 'dependences' and 'opts' keys.
--- Remove colorscheme also just need to delete it
--- from 'dependences' and 'opts'.

---@type LazySpec
return {
  "zaldih/themery.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- add colorscheme's name at here to let 'Themery' to manage it.
    themes = {
      "rose-pine-moon",
      "rose-pine-main",
      "tokyonight-moon",
      "tokyonight-night",
      "tokyonight-storm",
    },
  },
  -- add colorscheme as dependence to install and load them
  dependencies = {
    {
      "rose-pine/neovim",
      name = "rose-pine",
      opts = {},
    },
    {
      "folke/tokyonight.nvim",
      opts = {},
    },
  },
}
