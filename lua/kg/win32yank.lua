---@class Win32yank
---@field install_win32yank fun()
local M = {}

local utils = require("kg.utils")

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

---@param url string
---@param target string
---@return boolean
local function download_file(url, target)
  notify("Downloading: " .. url)
  local out = vim.fn.system({ "curl", "-L", "-o", target, url })
  if vim.v.shell_error ~= 0 then
    notify(string.format("Download failed:\n%s", out), vim.log.levels.WARN)
    return false
  end
  return true
end

---@param zip_path string
---@param target_dir string
---@return boolean
local function extract_zip(zip_path, target_dir)
  notify("Extracting to: " .. target_dir)
  local out = vim.fn.system({ "unzip", "-o", zip_path, "-d", target_dir })
  os.remove(zip_path)
  if vim.v.shell_error ~= 0 then
    notify(string.format("Extraction failed:\n%s", out), vim.log.levels.WARN)
    return false
  end
  return true
end

---@param path string
---@return boolean
local function make_executable(path)
  local out = vim.fn.system({ "chmod", "+x", path })
  if vim.v.shell_error ~= 0 then
    notify(string.format("chmod failed:\n%s", out), vim.log.levels.WARN)
    return false
  end
  return true
end

--- Install win32yank for WSL
function M.install_win32yank()
  assert(utils.is_wsl, "Only supports WSL")
  if not (jit.arch == "x86" or jit.arch == "x64") then
    notify("Unsupported architecture: " .. jit.arch, vim.log.levels.WARN)
    return
  end

  local install_dir = vim.fn.stdpath("data") .. "/win32yank"
  local exe_path = install_dir .. "/win32yank.exe"
  vim.env.PATH = install_dir .. ":" .. vim.env.PATH

  if vim.fn.executable("win32yank.exe") == 1 then return end

  local url = string.format(
    "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-%s.zip", jit.arch)
  local zip_path = os.tmpname() .. ".zip"

  if not download_file(url, zip_path) then return end
  if not extract_zip(zip_path, install_dir) then return end
  if not make_executable(exe_path) then return end

  notify("win32yank installed successfully")
end

return M
