--- Treesitter configurations and abstraction layer.
---
--- NOTE: (DEPENDENCE)
--- See also https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements
---

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- this plugin does not support lazy-loading.
  build = ":TSUpdate",
  branch = "master",
  main = "nvim-treesitter.configs",
  init = function() vim.opt.foldcolumn = "1" end,
  opts = {
    auto_install = true,
    ignore_install = {},
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
