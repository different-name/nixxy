{ lib, osConfig, ... }:
lib.mkIf (osConfig.networking.hostName == "iodine") {
  dyad.profiles = {
    # keep-sorted start
    minimal.enable = true;
    terminal.enable = true;
    # keep-sorted end
  };
}
