{ ... }:
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = true;
  };
}
