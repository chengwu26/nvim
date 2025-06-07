---@brief
---
--- Some QoL snacks. More details can refer to repositry
---
--- You can use 'Notify' command to display all notify history.
--- The command can also accept one or more level argument to
--- filter notifications
---

-- [[ Helper functions ]]
-- LSP progress
local function wrapper_lsp_progress_callback()
  ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
  local progress = vim.defaulttable()
  ---@param event {data: {client_id: integer, params: lsp.ProgressParams}}
  return function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local value = event.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == event.data.params.token then
        p[i] = {
          token = event.data.params.token,
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
    progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif) notif.icon = #progress[client.id] == 0 and " " or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
    })
  end
end

-- [[ Plugin configuration ]]
---@type LazySpec[]
return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      input = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      picker = {},
      scratch = {},
      indent = {
        enabled = true,
        chunk = {
          hl = "@character",
          enabled = true,
          char = { corner_top = "╭", corner_bottom = "╰" },
        },
      },
      notifier = {
        enabled = true,
        top_down = false,
        margin = { top = 0, right = 1, bottom = 1 },
      },
      scope = {
        enabled = true,
        treesitter = {
          blocks = { enabled = true },
        },
      },
      styles = {
        notification = { border = "single" },
      },
    },

    ---@param opts snacks.Config
    config = function(_, opts)
      require("snacks").setup(opts)

      ---@diagnostic disable-next-line: duplicate-set-field
      _G.dd = function(...) Snacks.debug.inspect(...) end
      ---@diagnostic disable-next-line: duplicate-set-field
      _G.bt = function() Snacks.debug.backtrace() end
      vim.print = _G.dd

      -- [[ LSP ]]
      local method = vim.lsp.protocol.Methods
      require("modules.lsp_config").setup({
        keys = {
          [method.textDocument_definition] = Snacks.picker.lsp_definitions,
          [method.textDocument_declaration] = Snacks.picker.lsp_declarations,
          [method.textDocument_implementation] = Snacks.picker.lsp_implementations,
          [method.textDocument_references] = Snacks.picker.lsp_references,
          [method.textDocument_documentSymbol] = Snacks.picker.lsp_symbols,
          [method.textDocument_typeDefinition] = Snacks.picker.lsp_type_definitions,
          [method.workspace_symbol] = Snacks.picker.lsp_workspace_symbols,
        },
        progress_callback = wrapper_lsp_progress_callback(),
      })
    end,

    keys = {
      --[[ Picker ]]
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      -- find
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config Files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- Grep
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Opened Buffers" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { "<leader>s\"", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- scratch
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- todo
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    },
  },
}
