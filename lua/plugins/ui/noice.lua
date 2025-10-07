---@type LazySpec
return {
  "folke/noice.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  event = "VeryLazy",
  ---@type NoiceConfig
  opts = { cmdline = { view = "cmdline" } },
}
