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
      "rose-pine-moon",
      "rose-pine-main",
      "duskfox",
      "nordfox",
      "terafox",
      "nightfox",
      "carbonfox",
      "rose-pine-dawn",
      "dayfox",
      "dawnfox",
    },
  },
  -- Add colorscheme as dependence to install and load them
  dependencies = {
    {
      "rose-pine/neovim",
      name = "rose-pine",
      opts = {},
    },
    {
      "EdenEast/nightfox.nvim",
      opts = {
        options = {
          styles = {
            comments = "italic",
          },
        },
      },
    },
  },
}
