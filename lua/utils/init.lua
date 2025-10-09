---@class Utils
---@field is_dev boolean
---@field env Env
---@field del_matching_group fun(pattern: string): integer
---@field foldtext function
local M = require("utils.var")

--- Delete all maching augroup and inside autocmds.
---@param pattern string
---@return integer # Number of deleted groups
function M.del_matching_group(pattern)
  ---@type integer[]
  local matchs = {}
  local autocmds = vim.api.nvim_get_autocmds({})

  for _, cmd in ipairs(autocmds) do
    local name = cmd.group_name
    if name and not vim.tbl_contains(matchs, cmd.group) and string.match(name, pattern) then
      table.insert(matchs, cmd.group)
    end
  end

  for _, group in ipairs(matchs) do
    vim.api.nvim_del_augroup_by_id(group)
  end
  return #matchs
end

-- [[ Fold Text ]]
function M.foldtext()
  return require("utils.foldtext").foldtext()
end

return M
