---@brief
---
--- https://github.com/EmmyLuaLs/emmylua-analyzer-rust
---
--- EmmyluaLs, a language server for Lua.
---
--- `emmylua_ls` can be installed using `cargo` by following the [instructions](https://github.com/EmmyLuaLs/emmylua-analyzer-rust#install).
---

local root_markers1 = {
  ".emmyrc.json",
  ".emmyrc.lua",
  ".luarc.json",
  ".luarc.jsonc",
}
local root_markers2 = {
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
}

---@type vim.lsp.Config
return {
  cmd = { "emmylua_ls", "--editor", "neovim" },
  filetypes = { "lua" },
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } }
      or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
  workspace_required = false,
  on_init = function(client)
    local root_dir = client.workspace_folders and client.workspace_folders[1].name
    if not root_dir then return end

    local in_neovim = root_dir == vim.fn.stdpath("config")
        or vim.startswith(root_dir, vim.env.VIMRUNTIME)

    if not in_neovim then return end

    local libraries = {
      vim.env.VIMRUNTIME,
      vim.fs.joinpath(vim.env.VIMRUNTIME, "lua"),
      "${3rd}/luv/library",
    }

    local data_path = vim.fn.stdpath("data") ---@cast data_path string
    local lazy_path = vim.fs.joinpath(data_path, "lazy")
    local handle = vim.uv.fs_scandir(lazy_path)
    if not handle then return end

    while true do
      local name, ty = vim.uv.fs_scandir_next(handle)
      if not name then break end
      if ty == "directory" then
        local lua_path = vim.fs.joinpath(lazy_path, name, "lua")
        if vim.uv.fs_stat(lua_path) then
          table.insert(libraries, lua_path)
        end
      end
    end

    local settings = client.config.settings or {}
    settings.emmylua = settings.emmylua or {}
    settings.emmylua.runtime = { version = "LuaJIT" }
    settings.emmylua.workspace = settings.emmylua.workspace or {}
    settings.emmylua.workspace.library = settings.emmylua.workspace.library or {}
    vim.list_extend(settings.emmylua.workspace.library, libraries)
    client.config.settings = settings
  end,
}
