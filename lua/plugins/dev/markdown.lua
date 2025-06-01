--- Preview markdown in browser.
---
--- NOTE: (DEPENDENCE)
--- npm, yarn
--- See also https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#installation--usage

-- install with yarn or npm
---@type LazySpec
return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
-- TODO: set keymap and option
