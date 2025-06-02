--- To see any one option's detail, type ':h <option>'

-- [[ Options ]]
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
    local url = "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x86.zip"
    local tmp_file = os.tmpname() .. ".zip"
    -- download win32yank
    local out = vim.fn.system({ "curl", "-L", "-o", tmp_file, url })

    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to download win32yank.exe:\n'%s'", out), vim.log.levels.WARN)
      return
    end

    local out = vim.fn.system({ "unzip", "-o", tmp_file, "-d", win32yank_dir })
    if vim.v.shell_error ~= 0 then
      vim.notify(string.format("Failed to extract files:\n'%s'", out), vim.log.levels.WARN)
      os.remove(tmp_file)
      return
    end

    os.remove(tmp_file)
    local out = vim.fn.system({ "chmod", "+x", win32yank_dir .. "/win32yank.exe" })
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
