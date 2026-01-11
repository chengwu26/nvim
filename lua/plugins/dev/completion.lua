---@type LazySpec
return {
  "saghen/blink.cmp",
  event = "LspAttach",
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  init = function()
    -- Disable native LSP completion
    require("kg.utils").del_matching_group("kg%.lsp%.complete")
  end,
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "super-tab", -- accept completion
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    completion = {
      documentation = { auto_show = true },
      keyword = { range = "prefix" },
      list = { selection = { auto_insert = false } },
    },
    cmdline = { enabled = false },
  },
}
