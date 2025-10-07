--- Git integrate

---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      ---@param mode string | string[]
      ---@param l string
      ---@param r string | function
      ---@param desc string
      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { desc = desc, buffer = bufnr })
      end

      map("n", "<leader>gd", gitsigns.diffthis, "Diff this")

      -- Navigation
      ---@param lhs string
      ---@param direction "first"|"last"|"prev"|"next"
      ---@param desc string
      local navi_map = function(lhs, direction, desc)
        map("n", lhs, function()
          if vim.wo.diff then
            vim.cmd.normal({ lhs, bang = true })
          else
            gitsigns.nav_hunk(direction)
          end
        end, desc)
      end
      navi_map("]h", "next", "Next Hunk")
      navi_map("]H", "last", "Last Hunk")
      navi_map("[h", "prev", "Prev Hunk")
      navi_map("[H", "first", "First Hunk")

      -- Action
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
      map("v", "<leader>gs",
        function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        "Stage These Lines")
      map("v", "<leader>gr",
        function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        "Reset These Lines")

      map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
      map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
      map("n", "<leader>gb", gitsigns.blame_line, "Blame Line")
      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
      map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview Inline")

      -- toggle
      map("n", "<leader>tW", gitsigns.toggle_word_diff, "Toggle Word Diff")
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Line Blame")

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
    end,
  },
}
