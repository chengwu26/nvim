local M = {}

---@param result table
---@param line string
---@param row integer
---@param col? integer
local function append_highlighted_segments(result, line, row, col)
  col = col or 0
  local segment = ""
  ---@type string
  local current_hl

  for i = 1, #line do
    local char = line:sub(i, i)
    local captures = vim.treesitter.get_captures_at_pos(0, row, col + i - 1)
    local capture = captures[#captures]
    local hl_group = capture and ("@" .. capture.capture) or nil

    if hl_group ~= current_hl then
      if #segment > 0 then
        table.insert(result, { segment, current_hl })
      end
      segment = char
      current_hl = hl_group
    else
      segment = segment .. char
    end
  end

  if #segment > 0 then
    table.insert(result, { segment, current_hl })
  end
end

function M.foldtext()
  local start_line = vim.fn.getline(vim.v.foldstart)
  local end_line = vim.fn.getline(vim.v.foldend)

  -- Replace tabs with spaces for consistent rendering
  local start_text = start_line:gsub("\t", string.rep(" ", vim.o.tabstop))
  local end_text = vim.trim(end_line)

  -- Calculate indent offset for end line
  local indent_offset = #(end_line:match("^(%s+)") or "")

  local result = {}
  append_highlighted_segments(result, start_text, vim.v.foldstart - 1)
  table.insert(result, { " ... ", "Delimiter" })
  append_highlighted_segments(result, end_text, vim.v.foldend - 1, indent_offset)

  return result
end

return M
