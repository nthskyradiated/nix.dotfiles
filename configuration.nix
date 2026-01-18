{ config, pkgs, lib, username, hostname, timezone, k8sHosts, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/networking.nix
    ./modules/system/audio.nix
    ./modules/system/bluetooth.nix
    ./modules/system/virtualization.nix
    ./modules/desktop/hyprland.nix
    ./modules/desktop/fonts.nix
    ./modules/optional/k8s-hosts.nix
    ./modules/development/ansible.nix
    ./modules/users/${username}.nix
  ];

  networking.hostName = hostname;
  time.timeZone = timezone;

  features.k8s-hosts.enable = true;

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
    vlc
    pavucontrol
    pamixer
    bluez
    bluez-tools
    brightnessctl
    swayosd
    cdrkit
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
