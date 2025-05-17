--- Code & cmdline completion

-- tip:
-- 1. <C-e> can hide completion menu
-- 2. in the cmdline, <C-y> accept
-- 3. in other case, <Enter> accept
---@type LazySpec
return {
  "saghen/blink.cmp",
  dependencies = {
    -- optional: provides snippets for the snippet source
    {
      "rafamadriz/friendly-snippets",
    },
    {
      "xzbdmw/colorful-menu.nvim",
      opts = {},
    },
  },
  event = "LspAttach",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "enter", -- accept completion
      -- select item
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-n>"] = {},
      ["<C-p>"] = {},

      -- scroll documentation
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
      },
    },
    completion = {
      documentation = {
        auto_show = true,
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
          components = {
            label = {
              text = function(ctx)
                return require("colorful-menu").blink_components_text(ctx)
              end,
              highlight = function(ctx)
                return require("colorful-menu").blink_components_highlight(ctx)
              end,
            },
          },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
}
