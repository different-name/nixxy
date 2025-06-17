{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.system.networking.enable = lib.mkEnableOption "Networking config";

  config = lib.mkIf config.nix-files.parts.system.networking.enable {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;

      firewall = {
        allowedUDPPorts = [ ];
        allowedTCPPorts = [ ];
      };
    };

    environment.persistence."/persist/system" =
      lib.mkIf config.nix-files.parts.system.persistence.enable
        {
          directories = [
            "/etc/NetworkManager/system-connections"
          ];
        };
  };
}
