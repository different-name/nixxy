{ lib, config, ... }:
let
  cfg = config.nix-files.home;
in
lib.mkIf (cfg.user == "iodine" && cfg.host == "iodine") {
  ### nix-files modules

  nix-files = {
    profiles.global.enable = true;
  };

  ### host specific

}
