--- Useless, but funny

---@type LazySpec
return {
  "Eandrju/cellular-automaton.nvim",
  ft = CODE_CONF_FT,
  config = function()
    local function setup_buffer_keymaps()
      vim.keymap.set(
        "n",
        "<leader>fr",
        "<CMD>CellularAutomaton make_it_rain<CR>",
        { buffer = true, desc = "Make it [R]ain" }
      )

      vim.keymap.set(
        "n",
        "<leader>fl",
        "<CMD>CellularAutomaton game_of_life<CR>",
        { buffer = true, desc = "Game of [L]ife" }
      )
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = CODE_CONF_FT,
      callback = setup_buffer_keymaps,
    })
  end,
}
