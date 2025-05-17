--- Highlight indent, chunk etc.

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
      exclude_filetypes = { "yazi" },
    },
    indent = {
      enable = true,
      exclude_filetypes = { "yazi" },
      style = {
        "#379392",
        "#4FB0C6",
        "#4F86C6",
        "#6C49B8",
      },
    },
  },
}
