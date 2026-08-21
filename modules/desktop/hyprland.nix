{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    # package = hyprland.packages.${pkgs.system}.hyprland;
    # portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };
}
