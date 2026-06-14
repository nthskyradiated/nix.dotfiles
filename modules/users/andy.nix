{ username, pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
    shell = pkgs.fish;
  };

  # services.getty.autologinUser = username;
}
