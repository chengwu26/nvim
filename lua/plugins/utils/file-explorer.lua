---
--- File explorer
---

---@type LazySpec
return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-t>"] = false,
      ["<C-l>"] = false,
      ["<F5>"] = "actions.refresh",
    },
  },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Explore Current Directory" })
  end,
}
