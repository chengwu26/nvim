## My Neovim Configuration
Base on [lazy.nvim](https://lazy.folke.io/)

### Neovim Startup Mode

This configuration supports a flexible startup level system based on command-line arguments,
allowing you to control which plugins are loaded depending on the launch context:

- `Minimal`: No plugins are loaded. Triggered when `vim.v.argv[1] == 'vi'`, e.g. `env -a vi nvim`
- `Basic`: Development plugins are skipped. Triggered when `vim.v.argv[1] == 'vim'`, e.g. `env -a vim nvim`
- `Full` (default): All plugins defined in this configuration are loaded

This mechanism is useful for optimizing performance, isolating development tools, or launching
Neovim in a clean state.

### Project layout
```
.
├── init.lua
├── lsp/                    lsp configuration
└── lua/
    ├── core/               core configuration(plugin-independent)
    │   ├── init.lua        load below files and enable custom features
    │   ├── autocmds.lua    gloabl default autocmds
    │   ├── keymaps.lua     gloabl default keymaps
    │   └── options.lua     gloabl default options
    ├── plugins/            plugins root directory
    │   ├── init.lua        setup lazy.nvim
    │   ├── utils/          utils plugins
    │   ├── ui/             ui improved plugins
    │   └── dev/            development plugins
    └── utils/              custom module
```

### Dependencies
- `Neovim` >= 0.11.4
- `Git` >= 2.19.0(for partial clones support)
- a Nerd Font
- `tar` and `curl`
- `treesitter-cli` >= 0.25.0
- a C compiler
- `Node` >= 23.0.0 (for some parsers)
- `unzip`
- `gzip`
- `yarn`
- [`rg`](https://github.com/BurntSushi/ripgrep)
- [`fd`](https://github.com/sharkdp/fd)(optional)
- For Windows, one of `7zip`, `peazip`, `archiver`, `winzip`, `WinRAR`

### Principle
- Maintainable
- Independent between plugins
  > make sure you can remove any modules/plugins and not break Neovim
- Reasonable lazy loading logic
