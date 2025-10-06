--- Useful tool

return {
  require("plugins.utils.treesitter"),
  require("plugins.utils.which-key"),     -- keymap helper
  require("plugins.utils.oil"),           -- file explorer
  require("plugins.utils.telescope"),     -- picker
  require("plugins.utils.todo-comments"), -- support todo comments
  require("plugins.utils.autopairs"),     -- bracket pair
  require("plugins.utils.csvview"),       -- improve csv/tsv
  require("plugins.utils.comment"),       -- (un)comment code
}
