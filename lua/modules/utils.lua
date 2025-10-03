---@brief
---
--- Provide some enhanced features
---

local M = {}

--- Current environment
---@type "Windows"|"Linux"|"WSL"|"OSX"|"BSD"|"POSIX"|"Other"
M.env = jit.os
if os.getenv("WSL_DISTRO_NAME") ~= nil then
  M.env = "WSL" -- In WSL
end

-- [[ Tmux Navigation ]]
do
  --- Seamless navigation with `tmux pane`
  ---@param direction 'h'|'j'|'k'|'l'
  M.smart_navigation = function(direction)
    local curr_wid = vim.api.nvim_get_current_win()
    local curr_win_conf = vim.api.nvim_win_get_config(curr_wid)
    if curr_win_conf.relative == "" then
      vim.cmd("wincmd " .. direction)
    end
    local new_wid = vim.api.nvim_get_current_win()

    -- Specified direction haven't window and `neovim` inside `tmux` now.
    -- Attempt focus `tmux` pane which specified direction, if any.
    if (curr_wid == new_wid) and vim.env.TMUX then
      local directions = { h = "-L", j = "-D", k = "-U", l = "-R" }
      vim.fn.system({ "tmux", "select-pane", directions[direction] })
    end
  end
end

return M
