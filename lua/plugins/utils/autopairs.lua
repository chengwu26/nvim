---
--- Auto pair bracket when input any bracket
---

---@type LazySpec
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    fast_wrap = {}, -- Enable fast_wrap, detail see documentation comment
    disable_in_visualblock = true,
  },
  config = function(_, opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    npairs.add_rule(Rule("$", "$", "typst"))
  end,
}
