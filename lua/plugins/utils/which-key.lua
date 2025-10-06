---@brief
---
--- Showing available keybindings in a popup as you type.
---
--- Keybindings should define in global keymap file(config/keymap.lua)
--- or plugin's configuration file(e.g plugins/ui/tabline.lua)
---

-- Tip: 'z=' show spelling suggestions
---@type LazySpec
return {
  "folke/which-key.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  ---@class wk.Opts
  opts = {
    ---@type false | "classic" | "modern" | "helix"
    preset = "helix",
    keys = {
      scroll_down = "<c-j>", -- Binding to scroll down inside the popup
      scroll_up = "<c-k>",   -- Binding to scroll up inside the popup
    },
    ---@type wk.Spec
    spec = {
      { "<leader>t", group = "Toggle" },
      { "<leader>b", group = "Buffer" },
      { "<leader>g", group = "Git" },
      { "<leader>f", group = "Fuzzy find" },
      { "gr",        group = "More LSP" },
    },
  },
}
