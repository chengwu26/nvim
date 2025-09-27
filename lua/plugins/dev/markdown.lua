--- Preview markdown in browser.
---
--- NOTE: (DEPENDENCE)
--- npm, yarn
--- See also https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#installation--usage

-- Install with yarn or npm
---@type LazySpec
return {
  "iamcco/markdown-preview.nvim",
  ft = "markdown",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_echo_preview_url = 1
    -- These two options needed to be inversed at the same time
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_combine_preview = 1
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        vim.keymap.set(
          "n",
          "<leader>tp",
          "<CMD>MarkdownPreviewToggle<CR>",
          { buffer = true, desc = "Toggle Markdown Preview" }
        )
      end,
    })
  end,
}
