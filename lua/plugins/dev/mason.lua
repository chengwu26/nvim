---@type LazySpec
return {
  -- NOTE: (DEPENDENCE)
  --  See also https://github.com/mason-org/mason.nvim?tab=readme-ov-file#requirements
  "mason-org/mason.nvim",
  cmd = "Mason",
  init = function()
    if jit.os == "Windows" then
      vim.env.PATH = vim.env.PATH .. ";" .. vim.fn.stdpath("data") .. "/mason/bin"
    else
      vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
    end
  end,
  ---@class MasonSettings
  opts = { PATH = "skip" },
}
