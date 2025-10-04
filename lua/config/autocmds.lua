---@brief
---
--- Default autocmd
---
--- If you want to see LSP-related autocmds, see `lua/config/lsp.lua`.
---
--- If you want to see plugin-related autocmds, they are in the plugin's
--- own configuration, go to `lua/plugins/` and look for them.
---

local cmd = vim.api.nvim_create_autocmd

-- Highlight text on yank
cmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function() vim.hl.on_yank() end,
})

-- Restore cursor position on file open
cmd("FileType", {
  desc = "Restore cursor position",
  callback = function(args)
    -- Don't apply to git messages
    local ft = vim.bo[args.buf].ft
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, "\"")
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
