---@brief
---
--- Default option
--- To see anyone option's detail, type ':h <option>'
---
--- If you want to see plugin-related/plugin-dependence options, they are in the
--- plugin's own configuration, go to `lua/plugins/` and look for them.
---

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
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }
opt.foldcolumn = "1"
opt.foldlevel = 5
opt.foldlevelstart = 5
opt.foldmethod = "expr"
opt.foldtext = ""
-- completion
opt.completeopt = { "menuone", "fuzzy", "noinsert", "popup" }
-- formatting
opt.formatoptions = "croqj"
-- diagnostic
vim.diagnostic.config({
  float = { severity_sort = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "●",
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
