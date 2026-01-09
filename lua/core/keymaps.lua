---
--- Default keymaps
---
--- Some keymaps are set dynamically, they are usually in `autocmds.lua`
---

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("i", "jk", "<ESC>")
map("n", "<ESC>", "<CMD>nohlsearch<CR>")
map("x", "/", "<ESC>/\\%V", { desc = "Search within visual selection" })
map("n", "L", vim.diagnostic.open_float, { desc = "Show Diagnostic" })
-- more consistent behavior of j/k when warp is set
map({ "n", "x" }, "j", "v:count ? 'j' : 'gj'", { expr = true })
map({ "n", "x" }, "k", "v:count ? 'k' : 'gk'", { expr = true })

-- Tabpage
map("n", "<M-,>", "<CMD>tabprevious<CR>", { desc = "Prev Tab" })
map("n", "<M-.>", "<CMD>tabnext<CR>", { desc = "Next Tab" })
map("n", "<M-<>", "<CMD>-tabmove<CR>", { desc = "Move tab left" })
map("n", "<M->>", "<CMD>+tabmove<CR>", { desc = "Move tab right" })
map("n", "<leader>tt", function()
  ---@diagnostic disable-next-line
  vim.opt.showtabline = vim.opt.showtabline:get() == 0 and 1 or 0
end, { desc = "Toggle Tabline" })

-- Text
map("n", "<C-s>", ":%s/", { desc = "Replace in buffer" })
map("x", "<C-s>", ":s/", { desc = "Replace within visual line" })
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down", silent = true })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up", silent = true })
map("x", "<leader>y", "\"+y", { desc = "Yank selection to clipboard" })
map("n", "<leader>y", "\"+yy", { desc = "Yank line to clipboard" })
map("n", "<leader>Y", "\"+y$", { desc = "Yank to EOL to clipboard" })
map("n", "<leader>p", "\"+p", { desc = "Put from clipboard" })

-- Window
local smart_navigation = require("utils.tmux").smart_navigation
map({ "n", "t" }, "<C-h>", function() smart_navigation("h") end,
  { desc = "Focus the left window/pane" })
map({ "n", "t" }, "<C-l>", function() smart_navigation("l") end,
  { desc = "Focus the right window/pane" })
map({ "n", "t" }, "<C-j>", function() smart_navigation("j") end,
  { desc = "Focus the lower window/pane" })
map({ "n", "t" }, "<C-k>", function() smart_navigation("k") end,
  { desc = "Focus the upper window/pane" })
map("n", "\\", "<CMD>sp<CR>", { desc = "Split window horizontally" })
map("n", "|", "<CMD>vsp<CR>", { desc = "Split window vertically" })

-- Options
map("n", "<leader>tw", "<CMD>set invwrap<CR>", { desc = "Toggle wrap" })
map("n", "<leader>tn", "<CMD>set invrnu<CR>", { desc = "Toggle relative number" })

-- Remove some default global keymaps
pcall(vim.keymap.del, "n", "<C-w>d")
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, { "n", "x" }, "gra")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "grt")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "gO")
pcall(vim.keymap.del, "i", "<C-s>")
