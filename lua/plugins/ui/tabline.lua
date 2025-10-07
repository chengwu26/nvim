--- Conveniently operate buffer

---@type LazySpec
return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = { "BufRead", "BufNewFile" },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      show_close_icon = false,
      show_buffer_close_icons = false,
    },
  },
  keys = {
    {
      "<leader>bb",
      "<CMD>BufferLinePick<CR>",
      desc = "Pick Buffer",
    },
    {
      "<leader>bc",
      "<CMD>BufferLinePickClose<CR>",
      desc = "Close Buffer",
    },
    {
      "<leader>bC",
      "<CMD>BufferLineCloseOthers<CR>",
      desc = "Close Other Buffers",
    },
    {
      "<leader>bp",
      "<CMD>BufferLineTogglePin<CR>",
      desc = "Pin Current Buffer",
    },
    {
      "<A-,>",
      "<CMD>BufferLineCyclePrev<CR>",
      desc = "Goto Previous Buffer",
    },
    {
      "<A-.>",
      "<CMD>BufferLineCycleNext<CR>",
      desc = "Goto Next Buffer",
    },
    {
      "<A-<>",
      "<CMD>BufferLineMovePrev<CR>",
      desc = "Move Buffer Previouos",
    },
    {
      "<A->>",
      "<CMD>BufferLineMoveNext<CR>",
      desc = "Move Buffer Next",
    },
  },
}
