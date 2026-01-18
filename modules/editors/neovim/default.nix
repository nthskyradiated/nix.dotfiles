# Main Neovim module - imports all submodules
{ config, pkgs, ... }:
let
  plugins = import ./plugins.nix { inherit pkgs; };
  options = import ./options.nix;
  keymaps = import ./keymaps.nix;
  ui = import ./ui.nix;
  lsp = import ./lsp.nix;
  completion = import ./completion.nix;
  navigation = import ./navigation.nix;
  treesitter = import ./treesitter.nix { inherit pkgs; };
  lint = import ./lint.nix;

  # Create unified snippets package
  customSnippets = pkgs.stdenv.mkDerivation {
    name = "custom-devops-snippets";
    buildCommand = ''
      mkdir -p $out
      cp ${../../development/snippets/kubernetes.json} $out/kubernetes.json
      cp ${../../development/snippets/ansible.json} $out/ansible.json
      cp ${../../development/snippets/az-pipelines.json} $out/az-pipelines.json
      cp ${../../development/snippets/package.json} $out/package.json
    '';
  };

in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = false;
    vimdiffAlias = true;
    plugins = plugins;
    extraLuaConfig = ''
      -- Leader key must be set first
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      -- Enable termguicolors FIRST before anything else
      if vim.fn.has('termguicolors') == 1 then
        vim.opt.termguicolors = true
      end
      ${options}
      ${ui}
      ${treesitter}
      ${lsp}
      ${completion}
      ${navigation}
      ${lint}
      ${keymaps}
    '';
  };

  # Create the unified snippets directory in XDG config
  xdg.configFile."nvim/snippets/custom" = {
    source = customSnippets;
  };
}
