{ lib, config, ... }:
lib.mkIf (config.nix-files.home.user == "iodine") {
  # user specific home configuration shared hosts

}
