---@brief
---
--- LSP config module
---
--- You can through the `setup` function to change the default configuration.
--- But for consistency, you can't change lhs. Thus you can replace the default
--- behavior with the plugin's api.
--- More detail see `setup` function.
---
--- The default configuration include:
--- - lsp basic keymaps
--- - toggle diagnostic virtual lines
--- - highlight symbol under cursor
--- - enable lsp auto completion
--- - lsp progress
---
--- To see default keymap, check `default_opts` and `preset_keys`.
---

---@class Config
---@field keys? table<vim.lsp.protocol.Methods, function>
---@field auto_completion? boolean
---@field progress_callback? fun(args: vim.api.keyset.create_autocmd.callback_args):boolean?

local M = {}

--[[ Helper Variables ]]
local methods = vim.lsp.protocol.Methods
local lsp_b = vim.lsp.buf

-- Default LSP keymap's rhs
--   key: method
--   value: rhs
---@type table<vim.lsp.protocol.Methods, function>
local default_rhs = {
  [methods.textDocument_rename] = lsp_b.rename,
  [methods.textDocument_codeAction] = lsp_b.code_action,
  [methods.textDocument_references] = lsp_b.references,
  [methods.textDocument_implementation] = lsp_b.implementation,
  [methods.textDocument_documentSymbol] = lsp_b.document_symbol,
  [methods.textDocument_signatureHelp] = lsp_b.signature_help,
  [methods.textDocument_definition] = lsp_b.definition,
  [methods.textDocument_declaration] = lsp_b.declaration,
  [methods.textDocument_typeDefinition] = lsp_b.type_definition,
  [methods.workspace_symbol] = lsp_b.workspace_symbol,
}

-- LSP keymap's lhs, desc, mode
--   key: method
--   value: { lhs, desc, mode }
local preset_lhs = {
  [methods.textDocument_rename] = { "grn", "Rename Symbol" },
  [methods.textDocument_codeAction] = { "gra", "Code Action", { "n", "v" } },
  [methods.textDocument_references] = { "grr", "Goto References" },
  [methods.textDocument_implementation] = { "gri", "Goto Implementation" },
  [methods.textDocument_documentSymbol] = { "gs", "List Buffer Symbol" },
  [methods.textDocument_signatureHelp] = { "<C-s>", "Show Signature Help", "i" },
  [methods.textDocument_definition] = { "gd", "Goto Definition" },
  [methods.textDocument_declaration] = { "gD", "Goto Declaration" },
  [methods.textDocument_typeDefinition] = { "grt", "Goto Type Definition" },
  [methods.workspace_symbol] = { "gS", "List Workspace Symbol" },
}

-- for highlight symbol under cursor
local function setup_hl_symbol(event)
  local highlight_augroup = vim.api.nvim_create_augroup("kg.lsp.highlight", { clear = false })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = event.buf,
    group = highlight_augroup,
    callback = lsp_b.document_highlight,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = event.buf,
    group = highlight_augroup,
    callback = lsp_b.clear_references,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("kg.lsp.detach", { clear = true }),
    callback = function(event2)
      lsp_b.clear_references()
      vim.api.nvim_clear_autocmds({ group = "kg.lsp.highlight", buffer = event2.buf })
    end,
  })
end

-- for toggle diagnostic
local wrapper_toggle_diagnostic = function()
  local cached_config
  return function()
    local virtual_lines = vim.diagnostic.config().virtual_lines
    if virtual_lines then
      cached_config = virtual_lines
      vim.diagnostic.config({ virtual_lines = false })
    else
      vim.diagnostic.config({ virtual_lines = cached_config or { current_line = true } })
    end
  end
end

---@type Config
local default_opts = {
  auto_completion = true,
  keys = default_rhs,
  progress_callback = function() vim.notify("LSP: " .. vim.lsp.status(), vim.log.levels.INFO) end,
}

-- [[ Setup ]]

-- Setup LSP config, you can use param `opts` to set custom behavior.
-- But each modification will inherit the last configuration
--
-- `opts`:
--   `auto_completion` (boolean): enable lsp auto completion, (default true)
--   `progress` (function): custom lsp progress notify
--   `keys` (table<vim.lsp.protocol.Methods, function>): custom lsp method behavior
--
-- Note: The setup of keymap and autocmd depends on LspAttach event. Don't call
-- this function in loads the plugin with the `LspAttach` event as conditional,
-- this may lead to undesired behavior.
--
---@param opts? Config
M.setup = function(opts)
  -- merge config
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", default_opts, opts)
  -- cache opts
  default_opts = opts

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Setup LSP Keymap",
    group = vim.api.nvim_create_augroup("kg.lsp.keymap", { clear = true }),
    callback = function(event)
      -- [[ Helper Variables ]]
      --- Set buffer-local keymap
      local lsp_client = vim.lsp.get_client_by_id(event.data.client_id)
      ---@param lhs string
      ---@param rhs string|function
      ---@param desc string
      ---@param mode? string | string[]
      local map = function(lhs, rhs, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      --- Check this client whether or not support the method
      ---@param method vim.lsp.protocol.Methods|string
      ---@return boolean
      local lsp_is_support = function(method)
        ---@diagnostic disable-next-line: param-type-mismatch, need-check-nil
        return lsp_client:supports_method(method, event.buf)
      end

      -- [[ Setup ]]
      -- keymaps
      for method, rhs in pairs(opts.keys) do
        if preset_lhs[method] and lsp_is_support(method) then
          map(preset_lhs[method][1], rhs, preset_lhs[method][2], preset_lhs[method][3])
        end
      end

      map("<leader>tl", wrapper_toggle_diagnostic(), "Toggle Diagnostic Lines")

      if lsp_is_support(methods.textDocument_inlayHint) then
        map(
          "<leader>th",
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end,
          "Toggle Inlay Hints"
        )
      end

      -- highlight symbol under cursor
      if lsp_is_support(methods.textDocument_documentHighlight) then
        setup_hl_symbol(event)
      end
    end,
  })

  -- completion
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Completion",
    group = vim.api.nvim_create_augroup("kg.lsp.completion", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
        vim.lsp.completion.enable(
          true,
          client.id,
          event.buf,
          { autotrigger = opts.auto_completion }
        )
      end
    end,
  })

  -- lsp progress
  vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Show LSP Progress",
    group = vim.api.nvim_create_augroup("kg.lsp.progress", { clear = true }),
    callback = opts.progress_callback,
  })
end

return M
