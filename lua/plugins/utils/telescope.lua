--- Fuzzy search
---
---  WARN: (DEPENDENCE)
---  Be careful remove this plugin. Because `nvim-lspconfig`'s
---  keymaps used this plugin's api. (file: lua/plugins/dev/lsp.lua).
---  if you want remove this plugin, make sure modify `nvim-lspconfig`'s
---  keymap configuration
---
---  NOTE: (DEPENDENCE)
---  ALL are optonal dependencies
---  See also https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#getting-started

---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  -- make sure extension `ui-sleelct` work correctly, so don't lazy load it.
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      -- NOTE: (DEPENDENCE)
      --  make: if haven't make, the extension will be disabled
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {},
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })
    pcall(require("telescope").load_extension, "fzf")
    require("telescope").load_extension("ui-select")
  end,
  keys = {
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>sf",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>ss",
      function()
        require("telescope.builtin").builtin()
      end,
      desc = "[S]earch [S]elect Telescope",
    },
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "[S]earch [D]iagnostics",
    },
    {
      "<leader>sr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[S]earch [R]esume",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          })
        )
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[S]earch [/] in Open Files",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
          prompt_title = "Find Neovim Files",
        })
      end,
      desc = "[S]earch [N]eovim files",
    },
  },
}
