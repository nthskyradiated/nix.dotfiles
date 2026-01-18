{ ... }:
{
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "Andy@Nixos";
        AutoEnable = true;
        FastConnectable = true;
      };
    };
  };
}
