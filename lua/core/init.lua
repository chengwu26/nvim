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
})

-- Enable enhanced feature
local utils = require("utils")
local features = require("features")

if utils.env == "WSL" then
  features.wsl_clipboard()
  features.smart_input_method()
end

if utils.env == "Windows" then
  features.smart_input_method()
end
