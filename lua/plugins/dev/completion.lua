---@type LazySpec
return {
  "saghen/blink.cmp",
  event = "LspAttach",
  version = "1.*",
  dependencies = {
    -- Optional: provides snippets for the snippet source
    {
      "rafamadriz/friendly-snippets",
    },
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "super-tab", -- accept completion
      -- Scroll documentation
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    completion = {
      documentation = {
        auto_show = true,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    cmdline = { enabled = false },
  },
  init = function()
    -- Disable LSP completion
    require("modules.lsp_config").setup({ auto_completion = false })
  end,
}
