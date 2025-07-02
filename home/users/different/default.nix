{ lib, config, ... }:
lib.mkIf (config.nix-files.home.user == "different") {
  # user specific home configuration shared hosts

}
