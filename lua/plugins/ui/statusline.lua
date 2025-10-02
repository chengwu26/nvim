--- Fancy status bar

---@type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      component_separators = { left = "|", right = "|" },
    },
  },
  init = function() vim.opt.showmode = false end,
}
