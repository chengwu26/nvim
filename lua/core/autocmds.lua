---
--- Default autocmds
---

local cmd = vim.api.nvim_create_autocmd

-- [[ General ]]
cmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function() vim.hl.on_yank() end,
})

cmd("FileType", {
  desc = "Restore cursor position",
  callback = function(args)
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

cmd("LspAttach", {
  desc = "LSP: Highlight symbol under the cursor",
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client:supports_method("textDocument/documentHighlight") then
      return
    end

    cmd({ "CursorHold", "CursorHoldI" }, {
      desc = "LSP: Highlight symbol under the cursor",
      buf = args.buf,
      callback = function()
        if client:is_stopped() then return true end
        vim.lsp.buf.document_highlight()
      end,
    })

    cmd({ "CursorMoved", "CursorMovedI" }, {
      desc = "LSP: Highlight symbol under the cursor",
      buf = args.buf,
      callback = function()
        if client:is_stopped() then return end
        vim.lsp.buf.clear_references()
      end,
    })
  end,
})

cmd("LspProgress", {
  desc = "LSP: Show LSP progress message",
  ---@param args {data: vim.event.lspprogress.data}
  callback = function(args)
    local value = args.data.params.value
    vim.api.nvim_echo({ { value.message or "done" } }, false, {
      id = "lsp.progress." .. args.data.client_id,
      kind = "progress",
      source = "vim.lsp",
      title = value.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = value.percentage,
    })
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
---  local utils = require("kg.utils")
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
    [methods.textDocument_inlayHint] = {
      mode = "n",
      lhs = "<leader>th",
      rhs = function(buffer)
        return function()
          vim.lsp.inlay_hint.enable(
            not vim.lsp.inlay_hint.is_enabled({ bufnr = buffer }),
            { bufnr = buffer }
          )
        end
      end,
      desc = "Toggle Inlay Hint",
    },
  }

  ---@param client vim.lsp.Client
  ---@param buffer integer
  local function setup_lsp_keymap(client, buffer)
    for method, keymap in pairs(preset) do
      if not client:supports_method(method, buffer) then
        goto continue
      end

      if method == methods.textDocument_inlayHint then
        vim.keymap.set(
          keymap.mode,
          keymap.lhs,
          keymap.rhs(buffer),
          { desc = "LSP: " .. keymap.desc, buf = buffer })
        goto continue
      end

      vim.keymap.set(
        keymap.mode,
        keymap.lhs,
        keymap.rhs,
        { desc = "LSP: " .. keymap.desc, buf = buffer }
      )

      ::continue::
    end
  end

  ---@param client vim.lsp.Client
  ---@param buffer integer
  local function setup_lsp_complete(client, buffer)
    if not client:supports_method(methods.textDocument_completion, buffer) then
      return
    end
    vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })
  end

  ---@param client vim.lsp.Client
  ---@param buffer integer
  local function setup_lsp_format_on_save(client, buffer)
    if not client:supports_method(methods.textDocument_formatting, buffer) then
      return
    end

    cmd("BufWritePre", {
      desc = "LSP: Auto-format on save",
      group = vim.api.nvim_create_augroup("kg.lsp.format.on_save.write_pre", { clear = false }),
      buf = buffer,
      callback = function()
        if client:is_stopped() then
          return true
        end
        vim.lsp.buf.format({ bufnr = buffer, id = client.id })
      end,
    })
  end

  cmd("LspAttach", {
    desc = "LSP: Keymap",
    group = vim.api.nvim_create_augroup("kg.lsp.keymap", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      setup_lsp_keymap(client, args.buf)
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Complete",
    group = vim.api.nvim_create_augroup("kg.lsp.complete", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      setup_lsp_complete(client, args.buf)
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Format",
    group = vim.api.nvim_create_augroup("kg.lsp.format.on_save", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      setup_lsp_format_on_save(client, args.buf)
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

  vim.lsp.handlers[methods.client_registerCapability] = (function(overridden)
    return function(err, res, ctx)
      local result = overridden(err, res, ctx) ---@diagnostic disable-line
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end

      for buffer, _ in pairs(client.attached_buffers) do
        local group_exists = pcall(vim.api.nvim_get_autocmds, { group = "kg.lsp.formata.on_save" })
        if group_exists and client:supports_method(methods.textDocument_formatting, buffer) then
          setup_lsp_format_on_save(client, buffer)
        end

        group_exists = pcall(vim.api.nvim_get_autocmds, { group = "kg.lsp.complete" })
        if group_exists and client:supports_method(methods.textDocument_completion, buffer) then
          setup_lsp_complete(client, buffer)
        end

        group_exists = pcall(vim.api.nvim_get_autocmds, { group = "kg.lsp.keymap" })
        if group_exists then
          setup_lsp_keymap(client, buffer)
        end
      end

      return result
    end
  end)(vim.lsp.handlers[methods.client_registerCapability])
end
