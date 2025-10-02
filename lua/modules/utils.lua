local M = {}

--- Whether or not in WSL
---@return boolean
M.is_wsl = function() return os.getenv("WSL_DISTRO_NAME") ~= nil end

--- Seamless navigation with `tmux pane`
---@param direction 'h'|'j'|'k'|'l'
M.smart_navigation = function(direction)
  local current_wid = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  local new_wid = vim.api.nvim_get_current_win()

  -- Specified direction haven't window and `neovim` inside `tmux` now.
  -- Attempt focus `tmux` pane which specified direction, if any.
  if (current_wid == new_wid) and vim.env.TMUX then
    local directions = { h = "-L", j = "-D", k = "-U", l = "-R" }
    vim.fn.system({ "tmux", "select-pane", directions[direction] })
  end
end

return M
