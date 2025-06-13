--- Useless, but funny

---@type LazySpec
return {
  "Eandrju/cellular-automaton.nvim",
  ft = CODE_CONF_FT,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = CODE_CONF_FT,
      callback = function(event)
        vim.keymap.set(
          "n",
          "<leader>cr",
          "<CMD>CellularAutomaton make_it_rain<CR>",
          { buffer = event.buf, desc = "Make it Rain" }
        )
        vim.keymap.set(
          "n",
          "<leader>cl",
          "<CMD>CellularAutomaton game_of_life<CR>",
          { buffer = event.buf, desc = "Game of Life" }
        )
      end,
    })
  end,
}
