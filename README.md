## My Neovim Configuration
Base on [lazy.nvim](https://lazy.folke.io/)

### Structure
``` mermaid
flowchart TD
    init.lua --> config
    config --> options.lua
    config --> keymaps.lua
    config --> autocmds.lua
    config --> lsp.lua

    init.lua --> modules

    init.lua --> plugins
    plugins --> ui
    plugins --> utils
    plugins --> dev
```
#### Details
- `config`: Global and plugin-independent configuration
- `modules`: Custom modules
- `plugins`: Setup lazy.nvim and configure plugins
  - `ui`: ui/apparence
  - `utils`: useful tools
  - `dev`: Development tools. This module disabled by default, modify `init.lua`(not plugins/init.lua) to enable

### Dependencies
You can search keyword "NOTE: (DEPENDENCE)" in this repository to inspect all dependencies and which
plugin dependence them.

- [neovim](https://neovim.io/) >= 0.11
- lazy.nvim's [dependencies](https://lazy.folke.io/#%EF%B8%8F-requirements)
- nvim-treesitter's [dependencies](https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements)
- mason's [dependencies](https://github.com/mason-org/mason.nvim?tab=readme-ov-file#requirements)
- npm & yarn (for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#installation--usage))
- curl & unzip (only WSL environment need)

##### For me
```zsh
sudo pacman -Syu git neovim luarocks lua51 npm yarn treesitter
# and any one nerd-font
```

### Principle
- Maintainable
- Independent between modules (as much as possible)
  > make sure you can remove any modules/plugin and not break neovim
- Reasonable lazy loading logic
