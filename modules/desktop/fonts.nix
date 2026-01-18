{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    adwaita-fonts
  ];
}
