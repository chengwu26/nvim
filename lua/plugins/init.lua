---
--- This module manages all plugins and their configuration
---
--- Plugin Manager: [lazy.nvim](https://lazy.folke.io/)
---
--- Plugins are divided into submodules (ui, utils, dev) according to their
--- main functionality. The dev modules can be disabled by set global variable
--- `ENABLE_DEV` to falsy or unset environment variable `DEV_ENV`.
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
  { import = "plugins.utils" },
  { import = "plugins.ui" },
}
table.insert(spec, { import = "plugins.dev", enabled = LEVEL > 1 })

require("lazy").setup({
  spec = spec,
  install = { colorscheme = { vim.g.colorscheme } },
  checker = { enabled = true },
  defaults = { version = false },
  rocks = { enabled = false },
  custom_keys = {
    ["<localleader>l"] = false,
  },
})
