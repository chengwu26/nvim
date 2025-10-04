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
      require("nvim-treesitter").install(ensure_install):wait(300000)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = CODE_CONF_FT,
        callback = function(args)
          vim.treesitter.start(args.buf)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    ft = CODE_CONF_FT,
    ---@type TSTextObjects.UserConfig
    opts = {},
    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = CODE_CONF_FT,
        callback = function(ev)
          local map = vim.keymap.set
          local ts_select = require("nvim-treesitter-textobjects.select").select_textobject
          local mode = { "x", "o" }
          --stylua: ignore start
          map(mode, "af", function()
            ts_select("@function.outer", "textobjects")
          end, { buffer = ev.buf, desc = "A function" })

          map(mode, "if", function()
            ts_select("@function.inner", "textobjects")
          end, { buffer = ev.buf, desc = "Inner function" })

          map(mode, "ac", function()
            ts_select("@class.outer", "textobjects")
          end, { buffer = ev.buf, desc = "A class" })

          map(mode, "ic", function()
            ts_select("@class.inner", "textobjects")
          end, { buffer = ev.buf, desc = "Inner class" })

          map(mode, "as", function()
            ts_select("@local.scope", "locals")
          end, { buffer = ev.buf, desc = "A scope" })
          --stylua: ignore end
        end,
      })
    end,
  },
}
