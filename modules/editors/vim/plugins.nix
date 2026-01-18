# Vim plugin declarations
{ pkgs, ... }:

let
  # Build tokyonight-vim from GitHub since it's not in nixpkgs
  tokyonight-vim = pkgs.vimUtils.buildVimPlugin {
    name = "tokyonight-vim";
    src = pkgs.fetchFromGitHub {
      owner = "ghifarit53";
      repo = "tokyonight-vim";
      rev = "master";
      sha256 = "sha256-ui/6xv8PH6KuQ4hG1FNMf6EUdF2wfWPNgG/GMXYvn/8=";
    };
  };
in
with pkgs.vimPlugins;
[
  # Theme
  tokyonight-vim

  # Fuzzy finding
  fzf-vim

  # LSP and completion
  vim-lsp
  vim-lsp-settings
  asyncomplete-vim
  asyncomplete-lsp-vim

  # Linting (NEW)
  ale

  # Status line
  lightline-vim

  # File navigation
  vim-startify
  undotree

  # Git
  vim-fugitive
  vim-gitgutter

  # Useful utilities
  vim-commentary
  vim-surround
  vim-repeat
  auto-pairs

  # Language support
  vim-terraform
  vim-go
  typescript-vim
  vim-javascript
  vim-nix

  # Snippets
  ultisnips
  vim-snippets
  asyncomplete-ultisnips-vim
]
