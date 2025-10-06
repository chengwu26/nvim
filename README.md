## My Neovim Configuration
Base on [lazy.nvim](https://lazy.folke.io/)

### Project layout
```
.
├── init.lua
├── lsp/                    lsp configuration
└── lua/
    ├── config/             core configuration(plugin-independent)
    │   ├── autocmds.lua
    │   ├── init.lua
    │   ├── keymaps.lua
    │   └── options.lua
    ├── plugins/            all plugins place there
    │   ├── init.lua        setup lazy.nvim
    │   ├── utils
    │   ├── ui
    │   └── dev
    ├── features.lua        custom enhanced features module
    └── utils.lua           custom utils module
```

### Dependencies
You can search keyword "NOTE: (DEPENDENCE)" in this repository to inspect all dependencies and which
plugin dependence them.

- [neovim](https://neovim.io/) >= 0.11
- lazy.nvim's [dependencies](https://lazy.folke.io/#%EF%B8%8F-requirements)
- nvim-treesitter's [dependencies](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements)
- mason's [dependencies](https://github.com/mason-org/mason.nvim?tab=readme-ov-file#requirements)
- yarn (for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#installation--usage))
- curl & unzip (only WSL environment need)

### Principle
- Maintainable
- Independent between plugins
  > make sure you can remove any modules/plugins and not break Neovim
- Reasonable lazy loading logic
