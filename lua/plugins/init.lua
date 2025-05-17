--- All plugins was configurated in this module.

-- define filetype for lazy load plugin according to filetype
-- program language
CODE_FT = {
  "python",
  "lua",
  "c",
  "cpp",
  "rust",
  "zsh",
}
-- config language
CONF_FT = {
  "yaml",
  "toml",
  "json",
}
-- both CODE_FT and CONFIG_FT
CODE_CONF_FT = vim.list_extend(vim.deepcopy(CODE_FT), CONF_FT)

-- [[ Bootstrap plugin manager 'lazy.nvim' ]]
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
--  There are three submodules (ui, tool and dev), and
--  plugins are divided into corresponding modules
local spec = {
  require("plugins.ui"),
  require("plugins.tool"),
}
-- NOTE: see the top init.lua
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
