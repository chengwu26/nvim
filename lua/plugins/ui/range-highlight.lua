---
--- Highlight selected line
---
--- For example the command ':10,20s/foo/bar/g', it will highlight the 10-20 lines.
---

---@type LazySpec
return {
  "winston0410/range-highlight.nvim",
  event = "CmdlineEnter",
  opts = {},
}
