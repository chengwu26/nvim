---@brief
---
--- LSP config module
---
--- You can through the `setup` function to change the default configuration.
--- For the consistency, you can't change lhs, but you can replace the default
--- behavior(e.g. rhs) with the plugin's API.
---
--- More detail see the `setup` function.
---
--- The default configuration include:
--- - LSP basic keymaps
--- - toggle diagnostic virtual lines
--- - highlight symbol under cursor
--- - enable LSP auto completion
--- - LSP progress
---
--- To see default keymap, check `preset`.
---

---@class Config
---@field rhs? table<vim.lsp.protocol.Methods, function>
---@field auto_complete? boolean
---@field progress_callback? fun(args: vim.api.keyset.create_autocmd.callback_args):boolean?

---@class LspKeymap
---@field lhs string
---@field rhs function
---@field mode string|string[]
---@field desc string

local M = {}

local methods = vim.lsp.protocol.Methods
local lsp_b = vim.lsp.buf

-- Default LSP keymap
---@type table<vim.lsp.protocol.Method, LspKeymap>
local preset = {
  [methods.textDocument_rename] = {
    lhs = "grn",
    rhs = lsp_b.rename,
    mode = "n",
    desc = "Rename Symbol",
  },
  [methods.textDocument_codeAction] = {
    lhs = "gra",
    rhs = lsp_b.code_action,
    mode = { "n", "v" },
    desc = "Code Action",
  },
  [methods.textDocument_references] = {
    lhs = "grr",
    rhs = lsp_b.references,
    mode = "n",
    desc = "Goto References",
  },
  [methods.textDocument_implementation] = {
    lhs = "gri",
    rhs = lsp_b.implementation,
    mode = "n",
    desc = "Goto Implementation",
  },
  [methods.textDocument_documentSymbol] = {
    lhs = "gs",
    rhs = lsp_b.document_symbol,
    mode = "n",
    desc = "List Buffer Symbol",
  },
  [methods.textDocument_signatureHelp] = {
    lhs = "<C-s>",
    rhs = lsp_b.signature_help,
    mode = "i",
    desc = "Show Signature Help",
  },
  [methods.textDocument_definition] = {
    lhs = "gd",
    rhs = lsp_b.definition,
    mode = "n",
    desc = "Goto Definition",
  },
  [methods.textDocument_declaration] = {
    lhs = "gD",
    rhs = lsp_b.declaration,
    mode = "n",
    desc = "Goto Declaration",
  },
  [methods.textDocument_typeDefinition] = {
    lhs = "grt",
    rhs = lsp_b.type_definition,
    mode = "n",
    desc = "Goto Type Definition",
  },
  [methods.workspace_symbol] = {
    lhs = "gS",
    rhs = lsp_b.workspace_symbol,
    mode = "n",
    desc = "List Workspace Symbol",
  },
}

---@type Config
local default_opts = {
  auto_complete = true,
  rhs = {},
  progress_callback = function() vim.notify("LSP: " .. vim.lsp.status(), vim.log.levels.INFO) end,
}

-- Setup LSP config, you can use param `opts` to set custom behavior.
-- But each modification will inherit the last configuration
--
-- `opts`:
--   `auto_complete` (boolean): enable LSP auto completion, (default true)
--   `progress_callback` (function): custom LSP progress notify
--   `rhs` (table<vim.lsp.protocol.Methods, function>): custom LSP method behavior
--
-- Note: The setup of keymap and autocmd depends on `LspAttach` event. Don't call
-- this function in loads the plugin with the `LspAttach` event as conditional,
-- this may lead to undesired behavior.
--
---@param opts? Config
M.setup = function(opts)
  -- merge config
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", default_opts, opts)
  default_opts = opts
  for method, rhs in pairs(opts.rhs) do
    if preset[method] then
      preset[method].rhs = rhs
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Setup LSP Keymap",
    group = vim.api.nvim_create_augroup("kg.lsp.keymap", { clear = true }),
    callback = function(event)
      --- Set buffer-local keymap
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      for method, keymap in pairs(preset) do
        if client and client:supports_method(method, event.buf) then
          vim.keymap.set(
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { desc = "LSP: " .. keymap.desc, buffer = event.buf }
          )
        end
      end

      if client and client:supports_method(methods.textDocument_inlayHint) then
        vim.keymap.set(
          "n",
          "<leader>th",
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end,
          { desc = "LSP: Toggle Inlay Hints" }
        )
      end

      -- highlight symbol under cursor
      if client and client:supports_method(methods.textDocument_documentHighlight) then
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
    end,
  })

  -- completion
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP Completion",
    group = vim.api.nvim_create_augroup("kg.lsp.completion", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(methods.textDocument_completion) then
        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = opts.auto_complete })
      end
    end,
  })

  -- LSP progress
  vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Show LSP Progress",
    group = vim.api.nvim_create_augroup("kg.lsp.progress", { clear = true }),
    callback = opts.progress_callback,
  })
end

return M
