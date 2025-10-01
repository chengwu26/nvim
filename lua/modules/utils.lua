local M = {}

--- Whether or not in WSL
---@return boolean
M.is_wsl = function() return os.getenv("WSL_DISTRO_NAME") ~= nil end

--- Seamless navigation with `tmux pane`
---@param direction 'h'|'j'|'k'|'l'
M.smart_navigation = function(direction)
  local current_wid = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  local new_wid = vim.api.nvim_get_current_win()

  -- Specified direction haven't window and `neovim` inside `tmux` now.
  -- Attempt focus `tmux` pane which specified direction, if any.
  if (current_wid == new_wid) and vim.env.TMUX then
    local directions = { h = "-L", j = "-D", k = "-U", l = "-R" }
    vim.fn.system({ "tmux", "select-pane", directions[direction] })
  end
end

local function check_environment()
  if jit.arch ~= "x86" or jit.arch ~= "x64" then
    vim.notify("Only support the x86 and x64 platform.", vim.log.levels.WARN)
    return false
  end
  if vim.fn.executable("curl") == 0 or vim.fn.executable("unzip") == 0 then
    vim.notify(
      "Failed to install win32yank: Please install curl and unzip first",
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

--- Install `win32yank` if it's not installed(dependencies: curl, unzip).
---
--- Note: This is just support the x86 and x64 platform.
---@return boolean
M.setup_win32yank = function()
  -- `win32yank` install directory
  local env_path = vim.env.PATH
  local win32yank_dir = vim.fn.stdpath("data") .. "/win32yank"
  vim.env.PATH = win32yank_dir .. ":" .. env_path

  if vim.fn.executable("win32yank.exe") == 1 then
    return true
  end

  -- Install `win32yank`
  -- Check environment
  if not check_environment() then
    return false
  end
  vim.notify("Download win32yank", vim.log.levels.INFO)
  local url = "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-%s.zip"
  url = string.format(url, jit.arch)
  local tmp_file = os.tmpname() .. ".zip"

  -- Download
  local out = vim.fn.system({ "curl", "-L", "-o", tmp_file, url })
  if vim.v.shell_error ~= 0 then
    vim.notify(string.format("Failed to download win32yank:\n%s", out), vim.log.levels.WARN)
    return false
  end

  -- Extract
  vim.notify("Extract files", vim.log.levels.INFO)
  out = vim.fn.system({ "unzip", "-o", tmp_file, "-d", win32yank_dir })
  if vim.v.shell_error ~= 0 then
    vim.notify(string.format("Failed to extract files:\n%s", out), vim.log.levels.WARN)
    os.remove(tmp_file)
    return false
  end

  -- Add execution mode
  os.remove(tmp_file)
  out = vim.fn.system({ "chmod", "+x", win32yank_dir .. "/win32yank.exe" })
  if vim.v.shell_error ~= 0 then
    vim.notify(string.format("Failed to add execution mode: %s", out), vim.log.levels.WARN)
    return false
  end

  vim.notify("Successed to install win32yank")
  return true
end

return M
