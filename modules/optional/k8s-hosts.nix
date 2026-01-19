{ lib, config, ... }:
with lib;
{
  options.features.k8s-hosts.enable = mkEnableOption "Kubernetes hosts";

  config = mkIf config.features.k8s-hosts.enable {
    networking.hosts = {
      "192.168.100.200" = [ "loadbalancer" ];
      "192.168.100.211" = [ "controlplane01" ];
      "192.168.100.212" = [ "controlplane02" ];
      "192.168.100.213" = [ "controlplane03" ];
      "192.168.100.221" = [ "node01" ];
      "192.168.100.222" = [ "node02" ];
      "192.168.100.223" = [ "node03" ];
      "127.0.0.1" = [ "azure-winds.myapp.sh" ];
      "127.0.0.1" = [ "auth.myapp.sh" ];
      "127.0.0.1" = [ "api.myapp.sh" ];


    };
  };
}
