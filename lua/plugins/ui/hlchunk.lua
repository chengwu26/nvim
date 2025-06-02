--- Highlight indent, chunk etc.

local exclude_filetypes = {
  yazi = true,
  mason = true,
  TelescopePrompt = true,
  snacks_notif_history = true,
}

---@type LazySpec
return {
  "shellRaining/hlchunk.nvim",
  ft = CODE_CONF_FT,
  opts = {
    chunk = {
      enable = true,
      delay = 250,
      duration = 70,
      style = "#F78500",
      exclude_filetypes = exclude_filetypes,
    },
    indent = {
      enable = true,
      exclude_filetypes = exclude_filetypes,
      style = {
        "#379392",
        "#4FB0C6",
        "#4F86C6",
        "#6C49B8",
      },
    },
  },
}
