## My Neovim Configuration
Base on [lazy.nvim](https://lazy.folke.io/)

### Principle
- Maintainable
- Independent between modules (as much as possible)
  > make sure you can remove any modules/plugin and not break neovim
- Reasonable lazy loading logic

### Structure
``` mermaid
flowchart TD
    entry[init.lua] --> config
    config --> option.lua
    config --> keymap.lua
    config --> autocmd.lua

    entry --> plugins
    plugins --> ui
    plugins --> utils
    plugins --> dev
```
#### Details
- `config`: Global and plugin-independent configuration
- `plugins`: Setup lazy.nvim and configurate plugins
  - `ui`: ui/apparence
  - `utils`: useful tools
  - `dev`: Development tools. This module disabled by default, modify `init.lua`(not plugins/init.lua) to enable

### Dependencies
You can search keyword "NOTE: (DEPENDENCE)" in this repository to inspect all dependencise and which
plugin dependence them.

- latest [neovim](https://neovim.io/)
- lazy.nvim's [dependencies](https://lazy.folke.io/#%EF%B8%8F-requirements)
- nvim-treesitter's [dependencies](https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#requirements)
- mason's [dependencies](https://github.com/mason-org/mason.nvim?tab=readme-ov-file#requirements)
- npm & yarn (for [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim?tab=readme-ov-file#installation--usage))
- curl & unzip (only WSL environment need)
- make (build [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim), optional)
- telescope.nvim's [dependencies](https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#getting-started) (optional)

##### For me
```zsh
sudo pacman -Syu git neovim luarocks lua51 npm yarn ripgrep fd treesitter
# and any one nerd-font
```
