# Main Vim module - imports all submodules
{ config, pkgs, ... }:

let
  plugins = import ./plugins.nix { inherit pkgs; };
  options = import ./options.nix;
  keymaps = import ./keymaps.nix;
  ui = import ./ui.nix;
  lsp = import ./lsp.nix;
  completion = import ./completion.nix;
  navigation = import ./navigation.nix;
in
{
  programs.vim = {
    enable = true;
    defaultEditor = false;

    plugins = plugins;

    settings = {
      number = true;
      relativenumber = true;
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
    };

    extraConfig = ''
      ${options}
      ${ui}
      ${lsp}
      ${completion}
      ${navigation}
      ${keymaps}
      ${builtins.readFile ./vim_ale_config.vim}
    '';
  };
}
