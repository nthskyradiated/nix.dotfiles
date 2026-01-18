{ username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "networkmanager" ];
  };

  services.getty.autologinUser = username;
}
