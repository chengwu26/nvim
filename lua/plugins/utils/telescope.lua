local blt = "telescope.builtin"

---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-symbols.nvim",
  },
  cmd = "Telescope",
  event = "LspAttach", -- Improve LSP features
  keys = {
    { "<leader>/",        function() require(blt).live_grep() end,                 desc = "Grep" },
    { "<leader>/",        function() require(blt).grep_string() end,               desc = "Search it",         mode = "v" },
    { "<leader>ff",       function() require(blt).find_files() end,                desc = "Files" },
    { "<leader>fg",       function() require(blt).git_files() end,                 desc = "Git files" },
    { "<leader>fb",       function() require(blt).current_buffer_fuzzy_find() end, desc = "This buffer" },
    { "<leader>fs",       function() require(blt).symbols() end,                   desc = "Symbols" },
    { "<leader>gc",       function() require(blt).git_bcommits() end,              desc = "Buffer's commits" },
    { "<leader>gc",       function() require(blt).git_bcommits_range() end,        desc = "Buffer's commits",  mode = "v" },
    { "<leader>gb",       function() require(blt).git_branches() end,              desc = "Branches" },
    { "<leader>gt",       function() require(blt).git_status() end,                desc = "Status" },
    { "<leader><leader>", function() require(blt).resume() end,                    desc = "Resume last picker" },
    { "<leader>d",        function() require(blt).diagnostics() end,               desc = "List diagnostics" },
  },
  opts = {
    defaults = {
      git_worktrees = {
        {
          toplevel = jit.os == "Linux" and vim.env.HOME or nil,
          gitdir = jit.os == "Linux" and vim.fs.joinpath(vim.env.HOME, ".dotfiles") or nil,
        },
      },
    },
  },
  config = function(_, opts)
    require("telescope").setup(opts)
    ---@type table<string, function>
    local builtin = require("telescope.builtin")
    vim.lsp.buf.references = builtin.lsp_references
    vim.lsp.buf.incoming_calls = builtin.lsp_incoming_calls
    vim.lsp.buf.outgoing_calls = builtin.lsp_outgoing_calls
    vim.lsp.buf.definition = builtin.lsp_definitions
    vim.lsp.buf.type_definition = builtin.lsp_type_definitions
    vim.lsp.buf.implementation = builtin.lsp_implementations
    vim.lsp.buf.document_symbol = builtin.lsp_document_symbols
    vim.lsp.buf.workspace_symbol = builtin.lsp_workspace_symbols
  end,
}
