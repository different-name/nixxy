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
    profiles.terminal.enable = true;
    system.perpetual.enable = true;
  };
}
