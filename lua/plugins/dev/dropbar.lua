--- Symbol navigate

--[[ Hlper function ]]
local function setup_buffer_keymaps()
  local dropbar_api = require("dropbar.api")

  ---@param lhs string
  ---@param rhs string | function
  ---@param desc string
  local map = function(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = true, desc = desc })
  end

  map("<Leader>;", dropbar_api.pick, "Pick symbol in winbar")
  map("[;", dropbar_api.goto_context_start, "Go to start of current context")
  map("];", dropbar_api.select_next_context, "Select next context")
end

-- [[ Plugin configuration ]]
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

    vim.api.nvim_create_autocmd("FileType", {
      pattern = CODE_CONF_FT,
      callback = setup_buffer_keymaps,
    })
  end,
}
