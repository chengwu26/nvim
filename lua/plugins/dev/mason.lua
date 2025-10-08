---
--- Develop tool manager
---

---@type LazySpec
return {
  "mason-org/mason.nvim",
  cmd = "Mason",
  init = function()
    local bin_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
    local sep = jit.os == "Linux" and ":" or ";"
    vim.env.PATH = vim.env.PATH .. sep .. bin_dir
  end,
  ---@class MasonSettings
  opts = { PATH = "skip" },
}
