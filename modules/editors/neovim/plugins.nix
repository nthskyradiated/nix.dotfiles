# Neovim plugin declarations
{ pkgs, ... }:

with pkgs.vimPlugins; [
  # Theme
  tokyonight-nvim

  # Telescope and dependencies
  telescope-nvim
  telescope-fzf-native-nvim
  plenary-nvim

  # Harpoon
  harpoon2

  # Treesitter
  (nvim-treesitter.withPlugins (p: [
    p.typescript
    p.javascript
    p.tsx
    p.go
    p.terraform
    p.json
    p.yaml
    p.lua
    p.vim
    p.vimdoc
    p.markdown
    p.python
    p.zig
    p.svelte
    p.bash
  ]))

  # LSP
  nvim-lspconfig

  # Autocompletion
  nvim-cmp
  cmp-nvim-lsp
  cmp-buffer
  cmp-path
  cmp-cmdline
  luasnip
  cmp_luasnip

  # Formatting
  conform-nvim
  nvim-lint

  # Git
  vim-fugitive
  gitsigns-nvim

  # UI and utilities
  undotree
  zen-mode-nvim
  which-key-nvim
  nvim-web-devicons
  lualine-nvim
  comment-nvim
]
