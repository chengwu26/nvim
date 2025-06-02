--- Some QoL snacks. More details can refer to repositry
---
--- [[ Notifier ]]
---  Use notifier implement LSP progress
---  You can use 'Notify' command to display notify history.
---   The command can also accept an argument to filter notifications

-- [[ Helper functions ]]

-- show lsp progress
---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
local function lsp_progress_callback(ev)
  local client = vim.lsp.get_client_by_id(ev.data.client_id)
  local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
  if not client or type(value) ~= "table" then
    return
  end

  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  local p = progress[client.id]

  for i = 1, #p + 1 do
    if i == #p + 1 or p[i].token == ev.data.params.token then
      p[i] = {
        token = ev.data.params.token,
        msg = ("[%3d%%] %s%s"):format(
          value.kind == "end" and 100 or value.percentage or 100,
          value.title or "",
          value.message and (" **%s**"):format(value.message) or ""
        ),
        done = value.kind == "end",
      }
      break
    end
  end

  local msg = {} ---@type string[]
  progress[client.id] = vim.tbl_filter(function(v)
    return table.insert(msg, v.msg) or not v.done
  end, p)

  local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
  vim.notify(table.concat(msg, "\n"), "info", {
    id = "lsp_progress",
    title = client.name,
    opts = function(notif)
      notif.icon = #progress[client.id] == 0 and " "
        or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

-- custom command 'Notify' to show notify history
local function notify_cmd(opts)
  -- default
  if vim.tbl_isempty(opts.fargs) then
    Snacks.notifier.show_history()
    return
  end
  -- filter notifications with the given keywords
  Snacks.notifier.show_history({
    filter = function(notif)
      return vim.list_contains(opts.fargs, notif.level)
    end,
  })
end

-- implement 'Notify' command's argument completion
local function notify_cmd_cmp(_, cmd_line)
  ---@type snacks.notifier.level[]
  local filters = { "trace", "debug", "info", "warn", "error" }

  local args = vim.list_slice(vim.split(cmd_line, "%s+"), 2, nil)

  local selected_filters = vim.list_slice(args, 1, #args - 1)
  local current_arg = args[#args] or ""

  local matches = {}
  for _, filter in ipairs(filters) do
    if
      not vim.tbl_contains(selected_filters, filter)
      and filter:find(current_arg, 1, true) == 1
    then
      table.insert(matches, filter)
    end
  end
  return matches
end

-- [[ Plugin configuration ]]
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true, top_down = false },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    --  NOTE: If you disabled the 'notifier', please remove these code below also
    vim.api.nvim_create_autocmd("LspProgress", { callback = lsp_progress_callback })

    vim.api.nvim_create_user_command(
      "Notify",
      notify_cmd,
      { desc = "Show notify history", nargs = "*", complete = notify_cmd_cmp }
    )
  end,
}
