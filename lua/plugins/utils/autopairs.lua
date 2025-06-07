---@brief
---
--- Auto pair bracket when input any bracket
---
--- FastWrap(INSERT mode):
--- Before        Input                    After         Note
--- -----------------------------------------------------------------
--- (|foobar      <A-e> then press $       (|foobar)
--- (|)(foobar)   <A-e> then press q       (|(foobar))
--- (|foo bar     <A-e> then press qh      (|foo) bar
--- (|foo bar     <A-e> then press qH      (foo|) bar
--- (|foo bar     <A-e> then press qH      (foo)| bar    if cursor_pos_before = false
---

---@type LazySpec
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    fast_wrap = {}, -- enable fast_wrap, detail see documentation comment
  },
}
