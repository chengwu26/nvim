---@brief
---
--- Basic keymap
---
--- If you want to see plugin-related keymaps, they are in the
--- plugin's own configuration, go to `lua/plugins/` and look for them.
---

local map = vim.keymap.set
-- basic
map("i", "jk", "<ESC>", { silent = true })
map(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true, desc = "Move cursor down" }
)
map(
  "x",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true, desc = "Move cursor down" }
)
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move cursor up" })
map("x", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move cursor up" })
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
-- Quick replace string
map("n", "<C-s>", ":%s/")
map("v", "<C-s>", ":s/")

-- window
---@param target_direction 'h'|'j'|'k'|'l'
local function smart_navigation(target_direction)
  local current_wid = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. target_direction)
  local new_wid = vim.api.nvim_get_current_win()

  -- Specified direction haven't window and `neovim` inside `tmux` now.
  -- Attempt focus `tmux` pane which specified direction, if any.
  if (current_wid == new_wid) and (vim.env.TMUX ~= nil) then
    local directions = { h = "L", j = "D", k = "U", l = "R" }
    vim.fn.system({ "tmux", "select-pane", "-" .. directions[target_direction] })
  end
end
map("n", "\\", "<CMD>sp<CR>", { desc = "Split window horizontally" })
map("n", "|", "<CMD>vsp<CR>", { desc = "Split window vertically" })
map("n", "<C-h>", function() smart_navigation("h") end, { desc = "Move focus to the left window" })
map("n", "<C-l>", function() smart_navigation("l") end, { desc = "Move focus to the right window" })
map("n", "<C-j>", function() smart_navigation("j") end, { desc = "Move focus to the lower window" })
map("n", "<C-k>", function() smart_navigation("k") end, { desc = "Move focus to the upper window" })

-- yank & put
map("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
map("n", "<leader>y", "\"+yy", { desc = "Yank line to clipboard" })
map("n", "<leader>Y", "\"+y$", { desc = "Yank to EOL to clipboard" })
map("n", "<leader>p", "\"+p", { desc = "Put from clipboard" })

-- options
map("n", "<leader>tw", "<CMD>set invwrap<CR>", { desc = "Toggle Wrap" })
map("n", "<leader>tn", "<CMD>set invrelativenumber<CR>", { desc = "Toggle Relative Number" })

-- Remove global LSP keymaps
vim.keymap.del("n", "grn")
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")
vim.keymap.del("i", "<C-s>")
