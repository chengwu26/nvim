---
--- To facilitate maintenance and plugin replacement, the configuration items
--- in this module should not depend on any plugins, ensuring that they remain
--- functional even after any plugin is removed.
---
--- For flexibility, these defaults can be overridden by plugins, but should not
--- change their semantics, e.g. the keymap 'grn' must be used to rename symbols.
---
--- Configuration that depend on plugins will be placed in the plugin's own
--- configuration file. This can be found in lua/plugins/xxx/xxx.lua
---

require("core.options")
require("core.keymaps")
require("core.autocmds")

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "jsonls",
  "marksman",
  "clangd",
})

-- Enable enhanced feature
---@type Utils
local utils = require("utils")
if utils.env == "WSL" then
  require("utils.install").install_win32yank()
end
