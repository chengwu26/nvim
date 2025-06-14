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
-- This solution use 'win32yank' to integrate system clipboard.
--  If not install win32yank, the code below will install it into `win32yank_dir`.
-- NOTE: (DEPENDENCE)
--  curl, unzip: install win32yank if it not installed (just for WSL)

if os.getenv("WSL_DISTRO_NAME") ~= nil then
  -- build win32yank's install directory
  local env_path = vim.env.PATH
  local win32yank_dir = vim.fn.stdpath("data") .. "/win32yank"
  vim.env.PATH = win32yank_dir .. ":" .. env_path

  if vim.fn.executable("win32yank.exe") == 0 then
    -- install win32yank
    vim.notify("Installing win32yank.exe")
    if vim.fn.executable("curl") == 0 or vim.fn.executable("unzip") == 0 then
      vim.notify("Failed to install win32yank:\nDon't have curl or unzip", vim.log.levels.WARN)
      return
    end
    local url = "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-%s.zip"
    if jit.arch == "x86" or jit.arch == "x64" then
      url = string.format(url, jit.arch)
    else
      vim.notify("Just support x86 and x64.")
      return
    end

    local tmp_file = os.tmpname() .. ".zip"
    -- download win32yank
    local out = vim.fn.system({ "curl", "-L", "-o", tmp_file, url })

    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to download win32yank.exe:\n'%s'", out), vim.log.levels.WARN)
      return
    end

    out = vim.fn.system({ "unzip", "-o", tmp_file, "-d", win32yank_dir })
    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to extract files:\n'%s'", out), vim.log.levels.WARN)
      os.remove(tmp_file)
      return
    end

    os.remove(tmp_file)
    out = vim.fn.system({ "chmod", "+x", win32yank_dir .. "/win32yank.exe" })
    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to add execution mode:\n'%s'", out), vim.log.levels.WARN)
      return
    end
    vim.notify("Successed to install win32yank")
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
