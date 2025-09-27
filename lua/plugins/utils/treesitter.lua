--- Tree-sitter configurations and abstraction layer.
---
--- NOTE: (DEPENDENCE)
--- See also https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements
---

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- This plugin does not support lazy-loading.
  build = ":TSUpdate",
  branch = "main",
  opts = {},
  config = function()
    require("nvim-treesitter").install(CODE_CONF_FT):wait(300000)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = CODE_CONF_FT,
      callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
