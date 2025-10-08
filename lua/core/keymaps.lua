---
--- Default keymaps
---
--- Some keymaps are set dynamically, they are usually in `autocmds.lua`
---

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("i", "jk", "<ESC>", { silent = true })
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
map("x", "/", "<ESC>/\\%V", { desc = "Search within Visual selection" })
map("n", "L", vim.diagnostic.open_float, { desc = "Show Diagnostic" })

-- Tabpage
map("n", "<M-,>", "<CMD>tabprevious<CR>", { desc = "Prev Tab" })
map("n", "<M-.>", "<CMD>tabnext<CR>", { desc = "Next Tab" })
map("n", "<M-<>", "<CMD>-tabmove<CR>", { desc = "Move Tab to Left" })
map("n", "<M->>", "<CMD>+tabmove<CR>", { desc = "Move Tab to Right" })
map("n", "<leader>tt", function()
  ---@diagnostic disable-next-line
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 1 or 0
end, { desc = "Toggle Tabline" })

-- More consistent behavior of j/k when warp is set
map({ "n", "x" }, "j", "v:count ? 'j' : 'gj'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count ? 'k' : 'gk'", { expr = true, silent = true })

-- Quick replace string
map("n", "<C-s>", ":%s/")
map("x", "<C-s>", ":s/")

-- Window operation
map("n", "\\", "<CMD>sp<CR>", { desc = "Split window horizontally" })
map("n", "|", "<CMD>vsp<CR>", { desc = "Split window vertically" })
local smart_navigation = require("utils").smart_navigation

map({ "n", "t" }, "<C-h>", function() smart_navigation("h") end,
  { desc = "Focus the left window/pane" })
map({ "n", "t" }, "<C-l>", function() smart_navigation("l") end,
  { desc = "Focus the right window/pane" })
map({ "n", "t" }, "<C-j>", function() smart_navigation("j") end,
  { desc = "Focus the lower window/pane" })
map({ "n", "t" }, "<C-k>", function() smart_navigation("k") end,
  { desc = "Focus the upper window/pane" })

-- Yank/Put to/from clipboard
map("v", "<leader>y", "\"+y", { desc = "Yank selection to clipboard" })
map("n", "<leader>y", "\"+yy", { desc = "Yank line to clipboard" })
map("n", "<leader>Y", "\"+y$", { desc = "Yank to EOL to clipboard" })
map("n", "<leader>p", "\"+p", { desc = "Put from clipboard" })

-- options
map("n", "<leader>tw", "<CMD>set invwrap<CR>", { desc = "Toggle Wrap" })
map("n", "<leader>tn", "<CMD>set invrnu<CR>", { desc = "Toggle Relative Number" })

-- Remove some default global keymaps
pcall(vim.keymap.del, "n", "<C-w>d")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, { "n", "v" }, "gra")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grt")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "gO")
pcall(vim.keymap.del, "i", "<C-s>")
