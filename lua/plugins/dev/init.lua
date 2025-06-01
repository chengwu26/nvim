--- Plugins about development

return {
  require("plugins.dev.gitsigns"), -- git integrate
  require("plugins.dev.treesitter"), -- grammer parser
  require("plugins.dev.comment"), -- (un)comment code
  require("plugins.dev.lsp"),
  require("plugins.dev.markdown"), -- markdown preview in browser
  require("plugins.dev.dropbar"), -- symbol navigate
}
