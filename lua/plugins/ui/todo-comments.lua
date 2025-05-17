--- Highlight todo, notes, etc in comments
---  keywords: FIX TODO HACK WARN PERF NOTE TEST
---  pattern = [[\b(KEYWORDS):]], -- ripgrep regex

---@type LazySpec
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = { signs = false },
  -- TODO: set keymap
}
