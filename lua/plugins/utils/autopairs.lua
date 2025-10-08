---
--- Auto pair bracket when input any bracket
---

---@type LazySpec
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    fast_wrap = {}, -- Enable fast_wrap, detail see documentation comment
  },
}
