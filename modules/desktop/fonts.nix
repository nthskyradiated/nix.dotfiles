{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    adwaita-fonts
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Liberation Serif" ];
      sansSerif = [ "FiraCode Nerd Font Mono" ];
      monospace = [ "JetBrains Mono" ];
    };
  };
}
