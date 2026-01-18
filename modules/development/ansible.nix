{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.python313.withPackages (ps: with ps; [
      ansible-core
      libvirt
      lxml
      xmltodict
    ]))
  ];
}
