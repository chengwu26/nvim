--- All plugins was configurated in this module.

-- [[ Bootstrap plugin manager 'lazy.nvim' ]]
-- NOTE: (DEPENDENCE)
-- See also https://lazy.folke.io/#%EF%B8%8F-requirements
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--  There are three submodules (ui, utils and dev), and
--  plugins are divided into corresponding modules
local spec = {
  require("plugins.ui"),
  require("plugins.utils"),
}

-- see the top init.lua
if ENABLE_DEV then
  table.insert(spec, require("plugins.dev"))
end

require("lazy").setup({
  spec = spec,
  defaults = { version = "*" },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
