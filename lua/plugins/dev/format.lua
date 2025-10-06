---@type LazySpec
return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    -- Auto format on save
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      -- lua = { "stylua" },
      -- python = { "isort", "black" }, -- TODO: fmt
      rust = { "rustfmt" },
    },
  },
}
