---@brief
---
--- Default LSP configuration
--- These configurations NOT dependent any plugin. You can overwite these
--- configurations in other plugin configuration through `modules.lsp_config`
--- module. So that if you remove those plugins, the basic lsp functions can
--- be fallback to default.
---

vim.lsp.enable({
  "lua_ls",
  "pyright",
  "rust_analyzer",
})

require("modules.lsp_config").setup()
