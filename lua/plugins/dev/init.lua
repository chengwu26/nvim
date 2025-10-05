--- Plugins about development

return {
  require("plugins.dev.gitsigns"), -- git integrate
  require("plugins.dev.comment"), -- (un)comment code
  require("plugins.dev.dropbar"), -- symbol navigate
  require("plugins.dev.mason"),
  require("plugins.dev.markdown"), -- markdown preview in browser
  require("plugins.dev.completion"),
  require("plugins.dev.format"),
}
