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
-- general
opt.swapfile = false
opt.undofile = true
opt.mouse = ""
opt.jumpoptions = "stack" -- more intuitive
opt.timeoutlen = 300
opt.updatetime = 250

-- display
opt.termguicolors = true
opt.smoothscroll = true
opt.title = true
opt.showmode = false -- use statusline plugin
opt.winborder = "single"
opt.cursorline = true

opt.wrap = false
opt.breakindent = true
opt.signcolumn = "auto"
opt.scrolloff = 5

opt.splitright = true
opt.splitbelow = true

opt.number = true
opt.relativenumber = true

-- tab & indent
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- search
opt.ignorecase = true
opt.smartcase = true

-- completion
opt.completeopt = { "menu", "fuzzy", "noselect", "popup", "preview" }

-- fold
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.foldcolumn = "1"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.fillchars = { eob = " ", fold = " ", foldopen = "", foldsep = " ", foldclose = "" }

-- [[ Custom fold-text]]
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

-- set fold-text color
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

-- [[ WSL clipboard integrate ]]
if os.getenv("WSL_DISTRO_NAME") ~= nil then
  local paste_cmd = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
    -NoLogo -NoProfile \
    -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace(\"`r\", \"\"))"

  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "/mnt/c/Windows/System32/clip.exe",
      ["*"] = "/mnt/c/Windows/System32/clip.exe",
    },
    paste = {
      ["+"] = paste_cmd,
      ["*"] = paste_cmd,
    },
    cache_enabled = true,
  }
end
