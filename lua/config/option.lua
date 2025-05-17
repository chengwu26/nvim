local opt = vim.opt
-- gerneral
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
opt.showmode = false -- use status line plugin

opt.cursorline = true
opt.wrap = false
opt.breakindent = true
opt.signcolumn = "yes"
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

-- If in WSL environment, use 'win32yank' to integrate system clipboard.
-- Note: In this case, must install win32yank.
--       <https://github.com/equalsraf/win32yank>
-- you can also use other solution
if os.getenv("WSL_DISTRO_NAME") ~= nil then
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
