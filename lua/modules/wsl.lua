---@brief
---
--- This modules provide some useful stuff in WSL environment.
---

local M = {}

-- [[ Clipboard ]]

---@return nil|string
local function check_environment()
  if jit.arch ~= "x86" or jit.arch ~= "x64" then
    return string.format("Only support the x86 and x64 platform, but on '%s'", jit.arch)
  end
  if vim.fn.executable("curl") == 0 then
    return "Missing dependency: 'curl' is required but not found"
  end
  if vim.fn.executable("unzip") == 0 then
    return "Missing dependency: 'unzip' is required but not found"
  end
end

--- Install `win32yank` to `install_dir`
---@param install_dir string
---@return nil|string
local function install_win32yank(install_dir)
  -- Install `win32yank`
  -- Check environment
  local res = check_environment()
  if res then
    return res
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

  vim.notify("Successed to install win32yank")
end

--- WSL integrate system clipboard.
---
--- This function will install `win32yank` if it's not installed
--- (dependencies: curl, unzip), and add the install directory to
--- `vim.env.PATH`.
---
--- Note: This is just support the x86 and x64 platform.
---@return nil|string
M.setup_clipboard = function()
  -- `win32yank` install directory
  local win32yank_dir = vim.fn.stdpath("data") .. "/win32yank"
  vim.env.PATH = win32yank_dir .. ":" .. vim.env.PATH

  if vim.fn.executable("win32yank.exe") == 0 then
    local res = install_win32yank(win32yank_dir)
    if res then
      return res
    end
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

return M
