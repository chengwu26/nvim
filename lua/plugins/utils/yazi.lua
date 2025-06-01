--- File explorer.
--- NOTE: (DEPENDENCE)
--- yazi
--- See also https://github.com/sxyazi/yazi

-- At first open yazi, open it in cwd
-- otherwise open last yazi session.
local is_first_open = true
local open_yazi = function()
  if is_first_open then
    is_first_open = false
    return vim.cmd(":Yazi")
  else
    return vim.cmd(":Yazi toggle")
  end
end

---@type LazySpec
return {
  "mikavilpas/yazi.nvim",
  -- NOTE: If the lazy-load method don't load this plugin utill neovim has opened.
  -- It will be cause a bit error: When you use neovim open a directory directly,
  -- neovim can't open yazi to ask you select a file.
  event = "VeryLazy",
  dependencies = "folke/snacks.nvim",
  ---@type YaziConfig | {}
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = "~",
    },
  },
  init = function()
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    -- vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
  keys = {
    {
      "<leader>e",
      open_yazi,
      desc = "open yazi",
    },
  },
}
