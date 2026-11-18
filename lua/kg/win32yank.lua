---@class Win32yank
---@field install_win32yank fun()
local M = {}

local utils = require("kg.utils")
local installing = false

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

---@param command string[]
---@param action string
---@param callback fun()
local function run(command, action, callback)
  vim.system(command, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local output = result.stderr ~= "" and result.stderr or result.stdout
        notify(string.format("%s failed:\n%s", action, output), vim.log.levels.WARN)
        installing = false
        return
      end
      callback()
    end)
  end)
end

-- Install win32yank for WSL-- Install win32yank for WSL
function M.install_win32yank()
  assert(utils.is_wsl, "Only supports WSL")
  if not (jit.arch == "x86" or jit.arch == "x64") then
    notify("Unsupported architecture: " .. jit.arch, vim.log.levels.WARN)
    return
  end

  local install_dir = vim.fn.stdpath("data") .. "/win32yank"
  local exe_path = install_dir .. "/win32yank.exe"
  vim.env.PATH = install_dir .. ":" .. vim.env.PATH

  if vim.fn.executable("win32yank.exe") == 1 then
    return
  end
  if installing then
    return
  end

  local url = string.format(
    "https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-%s.zip",
    jit.arch
  )
  local zip_path = os.tmpname() .. ".zip"
  installing = true

  local msg_id = "kg.win32yank.install"
  local msg_title = "win32yank"
  local msg_source = "kg.win32yank.install"
  vim.api.nvim_echo(
    { { "Downloading win32yank..." } },
    false,
    { id = msg_id, title = msg_title, source = msg_source, kind = "progress", status = "running" }
  )
  vim.net.request(
    url,
    { outpath = zip_path },
    vim.schedule_wrap(function(err)
      if err then
        vim.api.nvim_echo({ { "Download failed: " .. err } }, false, {
          id = msg_id,
          title = msg_title,
          source = msg_source,
          kind = "progress",
          status = "error",
        })
        installing = false
        os.remove(zip_path)
        return
      end

      vim.api.nvim_echo({ { "Downloaded. Extracting..." } }, false, {
        id = msg_id,
        title = msg_title,
        source = msg_source,
        kind = "progress",
        status = "success",
        percent = 100,
      })
      run({ "unzip", "-o", zip_path, "-d", install_dir }, "Extraction", function()
        os.remove(zip_path)
        run({ "chmod", "+x", exe_path }, "chmod", function()
          installing = false
          vim.api.nvim_echo({ { "win32yank Installed successfully" } }, false, {
            id = msg_id,
            title = msg_title,
            source = msg_source,
            kind = "progress",
            status = "success",
            percent = 100,
          })
        end)
      end)
    end)
  )
end

return M
