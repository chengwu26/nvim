--- Symbol navigate

---@type LazySpec
return {
  "Bekaboo/dropbar.nvim",
  ft = CODE_CONF_FT,
  ---@class dropbar_configs_t
  opts = {
    sources = {
      path = {
        ---@type boolean|fun(path: string): boolean?|nil
        preview = false, -- diable preview file
      },
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)

    local function setup_buffer_keymaps()
      vim.keymap.set(
        "n",
        "<Leader>;",
        require("dropbar.api").pick,
        { buffer = true, desc = "Pick symbol in winbar" }
      )

      vim.keymap.set(
        "n",
        "[;",
        require("dropbar.api").goto_context_start,
        { buffer = true, desc = "Go to start of current context" }
      )

      vim.keymap.set(
        "n",
        "];",
        require("dropbar.api").select_next_context,
        { buffer = true, desc = "Select next context" }
      )
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = CODE_CONF_FT,
      callback = setup_buffer_keymaps,
    })
  end,
}
