--- Preview markdown in browser.
---
--- install without yarn or npm
--- {
---     "iamcco/markdown-preview.nvim",
---     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
---     ft = { "markdown" },
---     build = function() vim.fn["mkdp#util#install"]() end,
--- }

-- install with yarn or npm
---@type LazySpec
return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
