---@brief
---
--- Default autocmd
---
--- If you want to see plugin-related autocmds, they are in the plugin's
--- own configuration, go to `lua/plugins/` and look for them.
---
--- The LSP-related autocmds also at here. These autocmds define many keymaps
--- and behaviors. But their implementations are very simple, so they are not
--- excellent to use. But these behaviors can be override by plugin, for more
--- details see the `[[ LSP ]]` section.
---

local cmd = vim.api.nvim_create_autocmd

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

-- [[ LSP ]]
-- Keymap:
--  You can see the default keymaps at the `preset` table. This table defined
--  the mapping between `vim.lsp.protocol.Method` and action. For consistency,
--  you shouldn't change their mappings. But you can use corresponding
--  implementations of the plugin override these actions, like this:
--  ```lua
--  vim.lsp.buf.rename = <plugin-lsp-api>
--  ```
--
-- Complete, Format and Highlight:
--  They also can be disable through
--  ```lua
--  vim.api.nvim_clear_autocmds{ group = "kg.lsp.complete" }
--  vim.api.nvim_clear_autocmds{ group = "kg.lsp.format" }
--  vim.api.nvim_clear_autocmds{ group = "kg.lsp.highlight" }
--  ```
--
do
  local has_group = require("modules.utils").has_augroup
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
    [methods.textDocument_documentSymbol] = {
      mode = "n",
      lhs = "gs",
      rhs = proxy.document_symbol,
      desc = "List Buffer Symbol",
    },
    [methods.textDocument_signatureHelp] = {
      mode = "i",
      lhs = "<C-s>",
      rhs = proxy.signature_help,
      desc = "Show Signature Help",
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
      lhs = "grt",
      rhs = proxy.type_definition,
      desc = "Goto Type Definition",
    },
    [methods.workspace_symbol] = {
      mode = "n",
      lhs = "gS",
      rhs = proxy.workspace_symbol,
      desc = "List Workspace Symbol",
    },
  }

  cmd("LspAttach", {
    desc = "LSP: Setup keymap",
    group = vim.api.nvim_create_augroup("kg.lsp.keymap", {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      -- Setup keymap
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
          { desc = "LSP: Toggle Inlay Hint" }
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
          callback = function()
            if not has_group("kg.lsp.highlight") then
              return true
            end
            vim.lsp.buf.document_highlight()
          end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = args.buf,
          group = hl_augroup,
          callback = function()
            vim.lsp.buf.clear_references()
            if not has_group("kg.lsp.highlight") then
              return true
            end
          end,
        })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = vim.api.nvim_create_augroup("kg.lsp.highlight.off", { clear = true }),
          callback = function(_args)
            if not has_group("kg.lsp.highlight") then
              return true
            end
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = hl_augroup, buffer = _args.buf })
          end,
        })
      end
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Complete",
    group = vim.api.nvim_create_augroup("kg.lsp.complete", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client:supports_method(methods.textDocument_completion) then
        local chars = {}
        for i = 32, 126 do
          table.insert(chars, string.char(i))
        end
        client.server_capabilities.completionProvider.triggerCharacters = chars
        vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
      end
    end,
  })

  cmd("LspAttach", {
    desc = "LSP: Format",
    group = vim.api.nvim_create_augroup("kg.lsp.format", { clear = true }),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if
        not client:supports_method(methods.textDocument_willSaveWaitUntil)
        and client:supports_method(methods.textDocument_formatting)
      then
        cmd("BufWritePre", {
          desc = "LSP: Auto-format on save",
          group = vim.api.nvim_create_augroup("kg.lsp.format.on_save", { clear = false }),
          buffer = args.buf,
          callback = function()
            -- If 'kg.lsp.format' group has been clear/delete, this autocmds also should be deleted
            if not has_group("kg.lsp.format") then
              return true
            end
            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
          end,
        })
      end
    end,
  })
end
