---@brief
--- File explorer
---

---@type LazySpec
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
      },
      float = {
        padding = 4,
      },
    },
    init = function()
      vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Explore Current Directory" })
    end,
  },
  {
    "JezerM/oil-lsp-diagnostics.nvim",
    dependencies = { "stevearc/oil.nvim" },
    event = "LspAttach",
    opts = {},
    config = function(_, opts)
      local diag_sign = vim.diagnostic.config().signs.text
      local default = {}
      if diag_sign then
        default = {
          diagnostic_symbols = {
            error = diag_sign[vim.diagnostic.severity.ERROR],
            warn = diag_sign[vim.diagnostic.severity.WARN],
            info = diag_sign[vim.diagnostic.severity.INFO],
            hint = diag_sign[vim.diagnostic.severity.HINT],
          },
        }
      end
      opts = vim.tbl_deep_extend("force", default, opts)
      require("oil-lsp-diagnostics").setup(opts)
    end,
  },
}
