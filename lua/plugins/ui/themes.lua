---@type LazySpec
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    integrations = {
      which_key = true,

      alpha = true,
      cmp = false,
      dap = false,
      dap_ui = false,
      dashboard = false,
      fzf = false,
      illuminate = { enabled = false },
      indent_blankline = { enabled = true },
      mini = false,
      neogit = false,
      neotree = false,
      nvimtree = false,
      rainbow_delimiters = false,
      render_markdown = false,
      treesitter_context = false,
      ufo = false,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme "catppuccin-mocha"
  end,
}
