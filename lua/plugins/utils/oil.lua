---
---@type LazySpec
return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  init = function()
    vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "[E]xplore current directory" })
  end,
}
