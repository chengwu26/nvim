---@brief
--- File explorer
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
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Explore Current Directory" })
  end,
}
