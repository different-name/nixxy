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
  dyad.profiles = {
    # keep-sorted start
    minimal.enable = true;
    terminal.enable = true;
    # keep-sorted end
  };
}
