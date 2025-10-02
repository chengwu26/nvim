---@brief
---
--- All configurations in this module are independent of any
--- plugin and must be used independently.
--- If you need to replace these default behaviors with plugin functionality,
--- you should override them in the plugin's own configuration.
---

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")

-- Enable enhanced feature
local utils = require("modules.utils")
local features = require("modules.features")
if utils.env == "WSL" then
  features.wsl_clipboard()
end
