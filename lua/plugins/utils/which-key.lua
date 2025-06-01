--- Showing available keybindings in a popup as you type.
---
--- Keybindings should define in global keymap file(config/keymap.lua)
--- or plugin's config file(e.g plugins/ui/tabline.lua)

-- tip: 'z=' show spelling suggestions
---@type LazySpec
return {
  "folke/which-key.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  ---@class wk.Opts
  opts = {
    ---@type false | "classic" | "modern" | "helix"
    preset = "helix",
    ---@type wk.Win.opts
    keys = {
      scroll_down = "<c-j>", -- binding to scroll down inside the popup
      scroll_up = "<c-k>", -- binding to scroll up inside the popup
    },
    spec = {
      { "<leader>t", group = "[T]oggle" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>b", group = "[B]uffer" },
      { "<leader>g", group = "[G]it" },
    },
  },
}
