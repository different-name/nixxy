{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (config.home) username;
  inherit (osConfig.networking) hostName;
in
lib.mkIf (username == "diffy" && hostName == "iodine") {
  dyad = {
    profiles = {
      # keep-sorted start
      terminal.enable = true;
      # keep-sorted end
    };

    system.perpetual.enable = true;
  };
}
