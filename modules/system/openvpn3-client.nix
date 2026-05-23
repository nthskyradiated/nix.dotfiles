{ config, lib, pkgs, ... }:

let
  cfg = config.services.openvpn3-client;
in
{
  options.services.openvpn3-client = with lib; {
    enable = mkEnableOption "OpenVPN 3 Linux client";

    package = mkOption {
      type = types.package;
      default = pkgs.openvpn3;
    };

    profiles = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    persistentProfiles = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {

    programs.openvpn3.enable = true;

    environment.systemPackages = [
      cfg.package
    ];

    systemd.services.openvpn3-import-profiles = lib.mkIf (cfg.profiles != [ ]) {
      description = "Import OpenVPN3 profiles";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script =
        let
          flag = if cfg.persistentProfiles then "--persistent" else "";
        in
        ''
          set -e

          ${lib.concatMapStringsSep "\n" (profile: ''
            echo "Importing: ${profile}"
            ${cfg.package}/bin/openvpn3 config-import \
              --config "${profile}" \
              ${flag} || true
          '') cfg.profiles}
        '';
    };
  };
}
