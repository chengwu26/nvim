---@brief
---
--- Provide some enhanced features
---

local utils = require("modules.utils")

local M = {}

-- [[ WSL Clipboard ]]
do
  --- Install `win32yank` to `install_dir`
  ---@param install_dir string
  ---@return nil|string
  local function install_win32yank(install_dir)
    -- Install `win32yank`
    -- Check environment
    if jit.arch ~= "x86" or jit.arch ~= "x64" then
      return string.format("Only support the x86 and x64 platform, but on '%s'", jit.arch)
    end

    local url = "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-%s.zip"
    url = string.format(url, jit.arch)
    local tmp_file = os.tmpname() .. ".zip"

    -- Download
    vim.notify("Download win32yank", vim.log.levels.INFO)
    local out = vim.fn.system({ "curl", "-L", "-o", tmp_file, url })
    if vim.v.shell_error ~= 0 then
      return string.format("Failed to download win32yank:\n%s", out)
    end

    -- Extract
    vim.notify("Extract files", vim.log.levels.INFO)
    out = vim.fn.system({ "unzip", "-o", tmp_file, "-d", install_dir })
    if vim.v.shell_error ~= 0 then
      os.remove(tmp_file)
      return string.format("Failed to extract files:\n%s", out)
    end

    -- Add execution mode
    os.remove(tmp_file)
    out = vim.fn.system({ "chmod", "+x", install_dir .. "/win32yank.exe" })
    if vim.v.shell_error ~= 0 then
      return string.format("Failed to add execution mode: %s", out)
    end

    vim.notify("Successed to install win32yank", vim.log.levels.INFO)
  end

  --- Setup WSL clipboard environment.
  ---
  --- This function will install `win32yank` if it's not installed
  --- (dependencies: curl, unzip), and add the install directory to
  --- `vim.env.PATH`.
  ---
  --- Note:
  ---   1. Only support the x86 and x64 platform.
  ---   2. Only can call this function in WSL environment.
  M.wsl_clipboard = function()
    assert(utils.env == "WSL", "Only for WSL")

    -- `win32yank` install directory
    local win32yank_dir = vim.fn.stdpath("data") .. "/win32yank"
    vim.env.PATH = win32yank_dir .. ":" .. vim.env.PATH

    if vim.fn.executable("win32yank.exe") == 1 then
      return
    end

    local res = install_win32yank(win32yank_dir)
    if res then
      vim.notify(res, vim.log.levels.WARN)
    end
  end
end

return M
