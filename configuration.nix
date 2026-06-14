{ config, pkgs, lib, username, hostname, timezone, hyprland, k8s-hosts, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/networking.nix
    ./modules/system/audio.nix
    ./modules/system/bluetooth.nix
    ./modules/system/virtualization.nix
    ./modules/system/openvpn3-client.nix
    ./modules/desktop/hyprland.nix
    ./modules/desktop/fonts.nix
    ./modules/optional/k8s-hosts.nix
    ./modules/development/ansible.nix
    ./modules/users/${username}.nix
  ];

  networking.hostName = hostname;
  time.timeZone = timezone;
  features.k8s-hosts.enable = true;
  services.openvpn3-client = {
    enable = true;
    profiles = [
      "/home/${username}/.config/openvpn/work.ovpn"
    ];
    persistentProfiles = true;
  };
  services.resolved.enable = true;
  environment.systemPackages = with pkgs; [
    tree
    wget
    ghostty
    waybar
    kitty
    wofi
    librewolf
    hyprpaper
    kdePackages.dolphin
    kdePackages.kget
    kdePackages.okular
    libreoffice-qt
    vlc
    pavucontrol
    pamixer
    bluez
    bluez-tools
    brightnessctl
    swayosd
    cdrkit
    ntfs3g
    adwaita-qt
    adwaita-qt6
    libsForQt5.qtstyleplugins
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.dconf.enable = true;

  programs.fish.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };

  system.stateVersion = "26.05";
}
