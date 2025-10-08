---
--- Default autocmds
---

local cmd = vim.api.nvim_create_autocmd

-- [[ General ]]
-- Highlight text on yank
cmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function() vim.hl.on_yank() end,
})

-- Restore cursor position on file open
cmd("FileType", {
  desc = "Restore cursor position",
  callback = function(args)
    -- Don't apply to git messages
    local ft = vim.bo[args.buf].ft
    if ft == "gitcommit" or ft == "gitrebase" then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, "\"")
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

--- [[ LSP ]]
--- Keymap:
---  You can see the default keymaps at the `preset` table. This table defined
---  the mapping between `vim.lsp.protocol.Method` and lSP action.
---  You can use corresponding implementations of the plugin override their
---  behavior, like this.
---  ```lua
---  vim.lsp.buf.rename = <plugin-lsp-rename-function>
---  ```
---  Then the 'grn' will call new function to rename the symbol.
---
--- Complete, Format and Highlight:
---  They also can be disable through
---  ```lua
---  local utils = require("utils")
---  utils.del_matching_group(kg%.lsp%.complete)  -- disable native complete
---  utils.del_matching_group(kg%.lsp%.format)    -- disable LSP auto-format
---  utils.del_matching_group(kg%.lsp%.highlight) -- disable symbol highlight
---  ```
---
do
  ---@class LspProxy
  ---@field rename fun()
  ---@field code_action fun()
  ---@field signature_help fun()
  ---@field references fun()
  ---@field implementation fun()
  ---@field definition fun()
  ---@field declaration fun()
  ---@field type_definition fun()
  ---@field document_symbol fun()
  ---@field workspace_symbol fun()
  ---@field incoming_calls fun()
  ---@field outgoing_calls fun()
  local proxy = setmetatable({}, {
    __index = function(_, key)
      return function(...) return vim.lsp.buf[key](...) end
    end,
  })
  local methods = vim.lsp.protocol.Methods
  local preset = {
    [methods.textDocument_rename] = {
      mode = "n",
      lhs = "grn",
      rhs = proxy.rename,
      desc = "Rename Symbol",
    },
    [methods.textDocument_codeAction] = {
      mode = { "n", "v" },
      lhs = "gra",
      rhs = proxy.code_action,
      desc = "Code Action",
    },
    [methods.textDocument_signatureHelp] = {
      mode = "i",
      lhs = "<C-s>",
      rhs = proxy.signature_help,
      desc = "Show Signature Help",
    },
    [methods.textDocument_references] = {
      mode = "n",
      lhs = "grr",
      rhs = proxy.references,
      desc = "Goto References",
    },
    [methods.textDocument_implementation] = {
      mode = "n",
      lhs = "gri",
      rhs = proxy.implementation,
      desc = "Goto Implementation",
    },
    [methods.textDocument_definition] = {
      mode = "n",
      lhs = "gd",
      rhs = proxy.definition,
      desc = "Goto Definition",
    },
    [methods.textDocument_declaration] = {
      mode = "n",
      lhs = "gD",
      rhs = proxy.declaration,
      desc = "Goto Declaration",
    },
    [methods.textDocument_typeDefinition] = {
      mode = "n",
      lhs = "grd",
      rhs = proxy.type_definition,
      desc = "Goto Type Definition",
    },
    [methods.textDocument_documentSymbol] = {
      mode = "n",
      lhs = "gs",
      rhs = proxy.document_symbol,
      desc = "List Buffer Symbol",
    },
    [methods.workspace_symbol] = {
      mode = "n",
      lhs = "gS",
      rhs = proxy.workspace_symbol,
      desc = "List Workspace Symbol",
    },
    [methods.callHierarchy_incomingCalls] = {
      mode = "n",
      lhs = "grc",
      rhs = proxy.incoming_calls,
      desc = "List Incoming Calls",
    },
    [methods.callHierarchy_outgoingCalls] = {
      mode = "n",
      lhs = "grC",
      rhs = proxy.outgoing_calls,
      desc = "List Outgoing Calls",
    },
    [methods.typeHierarchy_supertypes] = {
      mode = "n",
      lhs = "grt",
      rhs = function() vim.lsp.buf.typehierarchy("supertypes") end,
      desc = "List Supertypes",
    },
    [methods.typeHierarchy_subtypes] = {
      mode = "n",
      lhs = "grT",
      rhs = function() vim.lsp.buf.typehierarchy("subtypes") end,
      desc = "List Subtypes",
    },
  }

  cmd("LspAttach", {
    desc = "LSP: Keymap",
    group = vim.api.nvim_create_augroup("kg.lsp.keymap", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      for method, keymap in pairs(preset) do
        if client:supports_method(method) then
          vim.keymap.set(
            keymap.mode,
            keymap.lhs,
            keymap.rhs,
            { desc = "LSP: " .. keymap.desc, buffer = args.buf }
          )
        end
      end

      if client:supports_method(methods.textDocument_inlayHint) then
        vim.keymap.set(
          "n",
          "<leader>th",
          function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
              { bufnr = args.buf }
            )
          end,
          { desc = "LSP: Toggle Inlay Hint", buffer = args.buf }
        )
      end
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Highlight symbol under cursor",
    group = vim.api.nvim_create_augroup("kg.lsp.highlight", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client:supports_method(methods.textDocument_documentHighlight) then
        local hl_augroup = vim.api.nvim_create_augroup("kg.lsp.highlight.on", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = args.buf,
          group = hl_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = args.buf,
          group = hl_augroup,
          callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kg.lsp.highlight.off", {}),
          callback = function(_args)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = hl_augroup, buffer = _args.buf })
          end,
        })
      end
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Complete",
    group = vim.api.nvim_create_augroup("kg.lsp.complete", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client:supports_method(methods.textDocument_completion) then
        local chars = {}
        for i = 32, 126 do
          table.insert(chars, string.char(i))
        end
        client.server_capabilities.completionProvider.triggerCharacters = chars
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        vim.keymap.set("i", "<Tab>", 'pumvisible() ? "<C-y>" : "<Tab>"',
          { expr = true, noremap = true })
      end
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Format",
    group = vim.api.nvim_create_augroup("kg.lsp.format", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr"
      if
          not client:supports_method(methods.textDocument_willSaveWaitUntil)
          and client:supports_method(methods.textDocument_formatting)
      then
        cmd("BufWritePre", {
          desc = "LSP: Auto-format on save",
          group = vim.api.nvim_create_augroup("kg.lsp.format.on_save", { clear = false }),
          buffer = args.buf,
          callback = function()
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          end,
        })
      end
    end,
  })

  -- cmd("LspAttach", {
  --   desc = "LSP: Fold",
  --   callback = function(args)
  --     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
  --     if client:supports_method(methods.textDocument_foldingRange) then
  --       local win = vim.api.nvim_get_current_win()
  --       vim.wo[win][0].foldmethod = "expr"
  --       vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  --       vim.wo[win][0].foldtext = "v:lua.vim.lsp.foldtext()"
  --     end
  --   end,
  -- })
end
