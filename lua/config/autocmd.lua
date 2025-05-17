local cmd = vim.api.nvim_create_autocmd

-- highlight text on yank
cmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- restore cursor position on file open
cmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, "\"")
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
