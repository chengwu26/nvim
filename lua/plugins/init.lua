---@brief
---
--- This module manages all plugins and their configuration
---
--- Plugin Manager: [lazy.nvim](https://lazy.folke.io/)
---
--- Plugins are divided into submodules (ui, utils, dev) according
--- to their main functionality. The dev modules can be disabled by
--- set global variable `ENABLE_DEV` to false.
---

-- NOTE: (DEPENDENCE)
-- See https://lazy.folke.io/#%EF%B8%8F-requirements
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  require("plugins.ui"),
  require("plugins.utils"),
}
if ENABLE_DEV or os.getenv("DEV_ENV") then ---@diagnostic disable-line
  table.insert(spec, require("plugins.dev"))
end

require("lazy").setup({
  spec = spec,
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
