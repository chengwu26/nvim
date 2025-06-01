--- Conveniently operate buffer

---@type LazySpec
return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = { "BufRead", "BufNewFile" },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
    },
  },
  keys = {
    {
      "<leader>bb",
      "<CMD>BufferLinePick<CR>",
      desc = "Pick [B]uffer",
    },
    {
      "<leader>bc",
      "<CMD>BufferLinePickClose<CR>",
      desc = "[c]lose buffer",
    },
    {
      "<leader>bC",
      "<CMD>BufferLineCloseOthers<CR>",
      desc = "[C]lose All other buffers",
    },
    {
      "<leader>bp",
      "<CMD>BufferLineTogglePin<CR>",
      desc = "[P]in current buffer",
    },
    {
      "<A-,>",
      "<CMD>BufferLineCyclePrev<CR>",
      desc = "prev buffer",
    },
    {
      "<A-.>",
      "<CMD>BufferLineCycleNext<CR>",
      desc = "next buffer",
    },
    {
      "<A-<>",
      "<CMD>BufferLineMovePrev<CR>",
      desc = "move buffer prev",
    },
    {
      "<A->>",
      "<CMD>BufferLineMoveNext<CR>",
      desc = "move buffer next",
    },
  },
}
