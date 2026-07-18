{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.caskaydia-mono
    adwaita-fonts
    iosevka
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = [ "Liberation Serif" ];
      sansSerif = [ "jetBrainsMono Nerd Font Mono" ];
      monospace = [ "iosevka" ];
    };
  };
}
