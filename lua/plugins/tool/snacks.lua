--- Some QoL snacks. More details can refer to repositry

---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
  },
}
