-- Startup level, you can use `env -a vi nvim` to startup neovim and change the
-- `vim.v.argv[1]` to 'vi'.
-- There are three level:
--  pure: Neovim don't load any plugins, use this level when `argv[1]` is 'vi'
--  basic: Don't load development plugins, use this level when `argv[1]` is 'vim'
--  full (default): Load all plugins defined in this configuration
RT_LEVEL = {
  level = ({ vi = 0, vim = 1 })[vim.fs.basename(vim.v.argv[1])] or 2,
  is_basic = function(t)
    return t.level >= 1
  end,
  is_full = function(t)
    return t.level >= 2
  end,
}
-- Define your commonly used filetypes. This maybe control some plugin's load logic
-- Program language
CODE_FT = { "python", "lua", "c", "rust", "bash", "fish" }
-- Config and markup language
CONF_FT = { "yaml", "toml", "json", "markdown" }
CODE_CONF_FT = vim.list_extend(vim.deepcopy(CODE_FT), CONF_FT)

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = {
      [""] = "msg",
      empty = "cmd",
      emsg = "pager",
      echo = "msg",
      echomsg = "msg",
      echoerr = "pager",
      completion = "cmd",
      list_cmd = "pager",
      lua_error = "pager",
      lua_print = "pager",
      progress = "msg",
      rpc_error = "pager",
      quickfix = "msg",
      search_cmd = "cmd",
      search_count = "cmd",
      shell_cmd = "pager",
      shell_err = "pager",
      shell_out = "pager",
      shell_ret = "cmd",
      undo = "cmd",
      verbose = "pager",
      wildlist = "cmd",
      wmsg = "msg",
      typed_cmd = "cmd",
    },
  },
})

require("core")
if RT_LEVEL:is_basic() then
  require("plugins")
end
