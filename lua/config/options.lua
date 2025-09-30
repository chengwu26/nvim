---@brief
---
--- Basic option
--- To see anyone option's detail, type ':h <option>'
---
--- If you want to see plugin-related options, they are in the
--- plugin's own configuration, go to `lua/plugins/` and look for them.
---

-- [[ Options ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- [[ General ]]
opt.diffopt:append({ "algorithm:histogram" })
opt.helplang = "cn" -- Use Chinese documentation, but it doesn't work now.
opt.jumpoptions = "stack"
opt.matchpairs:append("<:>")
opt.mouse = ""
opt.shortmess = "aoOCF"
opt.showmatch = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.timeoutlen = 300
opt.title = true
opt.undofile = true
opt.updatetime = 250
opt.virtualedit = "block"
-- search
opt.ignorecase = true
opt.smartcase = true

-- [[ Appearance ]]
opt.conceallevel = 2
opt.cursorline = true
opt.guifont = "Maple Mono NF CN:h12"
opt.signcolumn = "yes:1"
opt.termguicolors = true
opt.winborder = "single"
-- scroll
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.smoothscroll = true
-- warp
opt.breakindent = true
opt.linebreak = true
opt.wrap = false
-- line number
opt.number = true
opt.relativenumber = true
-- tab & indent
opt.expandtab = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.shiftwidth = 2
opt.tabstop = 2

-- [[ Code ]]
-- fold
-- [[ Custom Fold-Text]]
-- Source: https://www.reddit.com/r/neovim/comments/1fzn1zt/custom_fold_text_function_with_treesitter_syntax/
local function fold_virt_text(result, start_text, lnum)
  local text = ""
  local hl
  for i = 1, #start_text do
    local char = start_text:sub(i, i)
    local captured_highlights = vim.treesitter.get_captures_at_pos(0, lnum, i - 1)
    local outmost_highlight = captured_highlights[#captured_highlights]
    if outmost_highlight then
      local new_hl = "@" .. outmost_highlight.capture
      if new_hl ~= hl then
        -- as soon as new hl appears, push substring with current hl to table
        table.insert(result, { text, hl })
        text = ""
        hl = nil
      end
      text = text .. char
      hl = new_hl
    else
      text = text .. char
    end
  end
  table.insert(result, { text, hl })
end

-- Set fold-text color
local function setup_fold_separator_hl()
  local hl_def = vim.api.nvim_get_hl(0, { name = "@comment.warning" })
  while hl_def.link and not hl_def.bg do
    hl_def = vim.api.nvim_get_hl(0, { name = hl_def.link })
  end
  vim.api.nvim_set_hl(0, "FoldSeparator", {
    fg = hl_def.bg,
    bg = "NONE",
    default = true,
  })
end

setup_fold_separator_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_fold_separator_hl,
})

function _G.custom_foldtext()
  local start_text = vim.fn.getline(vim.v.foldstart):gsub("\t", string.rep(" ", vim.o.tabstop))
  local nline = vim.v.foldend - vim.v.foldstart
  local result = {}
  fold_virt_text(result, start_text, vim.v.foldstart - 1)
  table.insert(result, { "  ", nil })
  table.insert(result, { "", "FoldSeparator" })
  table.insert(result, { "↙ " .. nline .. " lines", "@comment.warning" })
  table.insert(result, { "", "FoldSeparator" })
  return result
end
vim.opt.foldtext = "v:lua.custom_foldtext()"
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
opt.foldcolumn = "1"
opt.foldlevel = 5
opt.foldlevelstart = 5
opt.foldmethod = "expr"
-- completion
opt.completeopt = { "menuone", "fuzzy", "noinsert", "popup" }
-- formatting
opt.formatoptions = "croqj"
-- diagnostic
vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- [[ WSL Clipboard Integrate ]]
-- This solution use `win32yank` to integrate system clipboard.
local utils = require("modules.utils")
if utils.is_wsl() then
  if utils.setup_win32yank() then
    return
  end

  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
  }
end
