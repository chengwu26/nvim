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

    if vim.fn.executable("win32yank.exe") == 0 then
      local res = install_win32yank(win32yank_dir)
      if res then
        vim.notify(res, vim.log.levels.WARN)
        return
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
end

-- [[ Input Method Switch ]]
do
  --- Install im-select
  ---@return nil|string
  local install_im_select = function()
    assert(utils.env == "Windows" or utils.env == "WSL")
    local install_file = vim.fn.stdpath("data") .. "/im-select/im-select.exe"
    local url = "https://github.com/daipeihust/im-select/raw/master/win/out/x86/im-select.exe"

    -- Download
    vim.notify("Download im-select", vim.log.levels.INFO)
    local out = vim.fn.system({ "curl", "--create-dirs", "-L", "-o", install_file, url })
    if vim.v.shell_error ~= 0 then
      return string.format("Failed to download im-select:\n%s", out)
    end

    if jit.os == "Linux" then
      -- Add execution mode
      out = vim.fn.system({ "chmod", "+x", install_file })
      if vim.v.shell_error ~= 0 then
        return string.format("Failed to add execution mode: %s", out)
      end
    end

    vim.notify("Successed to install im-select", vim.log.levels.INFO)
  end

  --- Enable the smart input method feature's environment.
  ---
  --- This feature enables intelligent input method switching based on editor context,
  --- such as entering or leaving insert mode or exiting Neovim.
  ---
  --- Note: Only for Windows and WSL
  M.smart_input_method = function()
    assert(utils.env == "Windows" or utils.env == "WSL", "Only support Windows and WSL")

    local im_select = vim.fn.stdpath("data") .. "/im-select"
    local sep = utils.env == "WSL" and ":" or ";"
    vim.env.PATH = im_select .. sep .. vim.env.PATH
    if vim.fn.executable("im-select.exe") == 0 then
      local res = install_im_select()
      if res then
        vim.notify(res, vim.log.levels.WARN)
      end
    end

    local to_cn = function() vim.fn.system({ "im-select.exe", "2052" }) end
    local to_en = function() vim.fn.system({ "im-select.exe", "1033" }) end
    local gid = vim.api.nvim_create_augroup("kg.im-select", { clear = true })
    local cmd = vim.api.nvim_create_autocmd
    cmd("InsertEnter", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_cn,
    })
    cmd("InsertLeave", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_en,
    })
    cmd("VimEnter", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_en,
    })
    cmd("VimLeave", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_cn,
    })
    cmd("VimResume", {
      desc = "Input Method Switch",
      group = gid,
      callback = function()
        if vim.fn.mode() ~= "i" then
          to_en()
        end
      end,
    })
    cmd("VimSuspend", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_cn,
    })
    cmd("FocusGained", {
      desc = "Input Method Switch",
      group = gid,
      callback = function()
        if vim.fn.mode() ~= "i" then
          to_en()
        end
      end,
    })
    cmd("FocusLost", {
      desc = "Input Method Switch",
      group = gid,
      callback = to_cn,
    })
  end
end

return M
