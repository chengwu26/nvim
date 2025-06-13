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

-- window
map("n", "\\", "<CMD>:sp<CR>", { desc = "Split window horizontally" })
map("n", "|", "<CMD>:vsp<CR>", { desc = "Split window vertically" })
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
map("n", "<leader>y", "\"+yy", { desc = "Yank line to clipboard" })
map("n", "<leader>Y", "\"+y$", { desc = "Yank to EOL to clipboard" })
map("n", "<leader>p", "\"+p", { desc = "Put from clipboard" })

-- option
map("n", "<leader>tw", "<CMD>set invwrap<CR>", { desc = "Toggle Wrap" })
map("n", "<leader>tn", "<CMD>set invrelativenumber<CR>", { desc = "Toggle Relative Number" })

-- remove global LSP keymaps
vim.keymap.del("n", "grn")
vim.keymap.del({ "n", "v" }, "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")
vim.keymap.del("i", "<C-s>")
