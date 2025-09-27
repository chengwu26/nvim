---@brief
---
--- Highlight todo, notes, etc. in comments
--- keywords: FIX TODO HACK WARN PERF NOTE TEST
---

---@type LazySpec
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    signs = false,
    highlight = {
      pattern = [[.*\s<(KEYWORDS)\s*:]],
    },
    search = {
      pattern = [[ (KEYWORDS): ]],
    },
  },
}
