---@brief
---
--- All configurations in this module are independent of any
--- plugin and must be used independently.
--- If you need to replace these default behaviors with plugin functionality,
--- you should override them in the plugin's own configuration.
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
