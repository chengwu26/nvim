--- Git integrate
---
--- NOTE: (DEPENDENCE)
--- See also https://github.com/lewis6991/gitsigns.nvim#-requirements

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
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next Hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Prev Hunk")

      -- Action
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
      map(
        "v",
        "<leader>gs",
        function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        "Stage These Lines"
      )
      map(
        "v",
        "<leader>gr",
        function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
        "Reset These Lines"
      )

      map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
      map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
      map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview Inline")

      -- map("n", "<leader>gB", function() gitsigns.blame_line({ full = true }) end, "Blame Line (Full)")

      -- toggle
      map("n", "<leader>tW", gitsigns.toggle_word_diff, "Toggle Word Diff")
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Line Blame")

      -- Text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
    end,
  },
}
