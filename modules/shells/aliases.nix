{ hostname, ... }:
{
  cat = "bat";
  ls = "eza -l --icons";
  k = "kubectl";
  nrs = "sudo nixos-rebuild switch --flake ~/nix.dotfiles#${hostname}";
  nixdelgrub = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch && sudo nix-store --gc";

  ovpn-start = "openvpn3 session-start --config ~/.config/openvpn/work.ovpn";
  ovpnls = "openvpn3 sessions-list";
  ovpn-auth = "openvpn3 session-auth";
}
