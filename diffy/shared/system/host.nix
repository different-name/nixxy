{ lib, config, ... }:
let
  cfg = config.dyad.host;
in
{
  options.dyad.host = {
    machineId = lib.mkOption {
      type = lib.types.strMatching "[0-9a-f]{32}";
      description = "Systemd machine ID. Its first 8 characters also become networking.hostId";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      description = "NixOS release the host was installed with";
    };
  };

  config.nixos = {
    networking.hostId = lib.substring 0 8 cfg.machineId;
    environment.etc.machine-id.text = cfg.machineId;
    system.stateVersion = cfg.stateVersion;
  };
}
