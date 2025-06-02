--- Global keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

---@param mode string | string[]
---@param lhs string
---@param rhs string | function
---@param desc? string
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end

map("i", "jj", "<ESC>")
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
map("t", "<ESC><ESC>", "<C-\\><C-n>", "Exit termianl mode")

map("n", "<C-h>", "<C-w><C-h>", "Move focus to the left window")
map("n", "<C-l>", "<C-w><C-l>", "Move focus to the right window")
map("n", "<C-j>", "<C-w><C-j>", "Move focus to the lower window")
map("n", "<C-k>", "<C-w><C-k>", "Move focus to the upper window")

map("v", "<leader>y", "\"+y", "[Y]ank to clipboard")
map("n", "<leader>y", "\"+yy", "[y]ank line to clipboard")
map("n", "<leader>Y", "\"+y$", "[Y]ank to EOL to clipboard")
map("n", "<leader>p", "\"+p", "[P]ut from clipboard")

map("n", "<leader>tw", "<CMD>set invwrap<CR>", "Toggle [W]rap")
map("n", "<leader>tn", "<CMD>set invrelativenumber<CR>", "Toggle relative[N]umber")
