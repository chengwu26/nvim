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

      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line [B]lame")
      map("n", "<leader>gd", gitsigns.diffthis, "[D]iff this")

      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "next hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "prev hunk")
    end,
  },
}
