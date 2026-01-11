---@brief
---
--- https://github.com/luals/lua-language-server
---
--- Lua language server.
---
--- `lua-language-server` can be installed by following the instructions [here](https://luals.github.io/#neovim-install).
---
--- The default `cmd` assumes that the `lua-language-server` binary can be found in `$PATH`.

--- Wether or not loaded neovim library
local has_loaded = false

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".emmyrc.json",
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      format = {
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          max_line_length = "100",
          end_of_line = "lf",
          trailing_table_separator = "smart",
        },
      },
      workspace = { checkThirdParty = false },
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
      diagnostics = {
        libraryFiles = "Disable",
        groupFileStatus = {
          strict = "Opened",
          strong = "Opened",
          ambiguity = "Opened",
          duplicate = "Opened",
          global = "Opened",
          luadoc = "Opened",
          redefined = "Opened",
          ["type-check"] = "Opened",
          unbalanced = "Opened",
          unused = "Opened",
        },
        groupSeverity = {
          strong = "Warning",
          strict = "Warning",
        },
        unusedLocalExclude = { "_*" },
      },
    },
  },
  --- Check wether or not in the neovim config directory and if so,
  --- load the relevant libraries.
  ---@param client vim.lsp.Client
  on_attach = function(client, _)
    if has_loaded then return end
    local is_wthin_runtime_path = false
    for _, path in ipairs(vim.opt.runtimepath:get()) do
      if client.root_dir:sub(1, #client.root_dir) == path then
        is_wthin_runtime_path = true
        break
      end
    end
    if not is_wthin_runtime_path then return end

    has_loaded = true
    local extras_library = { vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"), "${3rd}/luv/library" }
    local lazy_path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
    local handle = vim.uv.fs_scandir(lazy_path)
    if not handle then return end

    while true do
      local name, ty = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if ty == "directory" then
        local lua_path = vim.fs.joinpath(lazy_path, name, "lua")
        if vim.uv.fs_stat(lua_path) then
          table.insert(extras_library, lua_path)
        end
      end
    end

    local settings = client.config.settings or {}
    settings.Lua = settings.Lua or {}
    settings.Lua.runtime = { version = "LuaJIT" } ---@diagnostic disable-line: inject-field
    settings.Lua.workspace = settings.Lua.workspace or {} ---@diagnostic disable-line: inject-field
    settings.Lua.workspace.library = settings.Lua.workspace.library or {}
    vim.list_extend(settings.Lua.workspace.library, extras_library)
    client:notify(
      vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
      { settings = settings }
    )
  end,
}
