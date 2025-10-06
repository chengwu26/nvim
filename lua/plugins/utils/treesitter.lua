--- Tree-sitter configurations and abstraction layer.
---
--- NOTE: (DEPENDENCE)
--- See also https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements
---

---@type LazySpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- This plugin does not support lazy-loading.
    build = ":TSUpdate",
    branch = "main",
    config = function()
      local ensure_install = vim.list_extend(vim.deepcopy(CODE_CONF_FT), { "regex" })
      local ts = require("nvim-treesitter")
      ts.install(ensure_install):wait(300000)

      local ft = {}
      for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
        vim.list_extend(ft, vim.treesitter.language.get_filetypes(lang))
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function(args)
          vim.treesitter.start(args.buf)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    branch = "main",
    ft = function()
      local ft = {}
      for _, lang in ipairs(require("nvim-treesitter").get_installed()) do
        vim.list_extend(ft, vim.treesitter.language.get_filetypes(lang))
      end
      return ft
    end,
    ---@type TSTextObjects.UserConfig
    opts = {},
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local map = vim.keymap.set
          local ts_select = require("nvim-treesitter-textobjects.select").select_textobject
          local mode = { "x", "o" }
          map(mode, "af", function()
            ts_select("@function.outer", "textobjects")
          end, { buffer = args.buf, desc = "A function" })

          map(mode, "if", function()
            ts_select("@function.inner", "textobjects")
          end, { buffer = args.buf, desc = "Inner function" })

          map(mode, "ac", function()
            ts_select("@class.outer", "textobjects")
          end, { buffer = args.buf, desc = "A class" })

          map(mode, "ic", function()
            ts_select("@class.inner", "textobjects")
          end, { buffer = args.buf, desc = "Inner class" })

          map(mode, "as", function()
            ts_select("@local.scope", "locals")
          end, { buffer = args.buf, desc = "A scope" })
        end,
      })
    end,
  },
}
