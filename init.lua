---
--- NOTE: This configuration contain some plugins about development.
--- To avoid installing them when they are not needed, such as root user,
--- they are disabled by default.
--- You must explicitly enable them by defining global variable `ENABLE_DEV = true`
--- or environment variable `DEV_ENV`
--- ---
--- Priority:
---  Lua Variable > Environment Variable
---

-- Define your commonly used filetypes. This maybe control some plugin's load logic
-- Program language
CODE_FT = { "python", "lua", "c", "rust", "bash", "zsh" }
-- Config and markup language
CONF_FT = { "yaml", "toml", "json", "markdown" }
CODE_CONF_FT = vim.list_extend(vim.deepcopy(CODE_FT), CONF_FT)

require("core")
require("plugins")
