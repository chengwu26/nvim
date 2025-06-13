---@brief
---
--- This Neovim configuration has some dependencies, which are annotated
--- with `NOTE: (DEPENDENCE)` keyword at the plugin location with the
--- dependency. You can search for this keyword to see them. Or if you have
--- already loaded this configuration, you can use `<leader>st' and then enter
--- the keyword to quickly see them.
---

-- NOTE: The configuration contain some plugins about development.
-- To avoid installing them when they are not needed, like root user,
-- they are disabled by default.
-- To enable them, you just set ENABLE_DEV = true or undefine it.
ENABLE_DEV = false

-- Define filetype for lazy loading plugins according to filetype.
-- If some plugins (lsp, hlchunk etc.) have unexpected loading behavior,
--  add/remove the filetype into/from `CODE_FT` or `CONF_FT`. General, remove
--  a filetype from them, some plugins (lsp, hlchunk etc.) will not load when
--  open this filetype.

--- Program language
---@type string[]
CODE_FT = { "python", "lua", "c", "cpp", "rust" }

--- Config language
---@type string[]
CONF_FT = { "yaml", "toml", "json", "markdown" }

--- Both `CODE_FT` and `CONFIG_FT`
---@type string[]
CODE_CONF_FT = vim.list_extend(vim.deepcopy(CODE_FT), CONF_FT)

require("config")
require("plugins")
