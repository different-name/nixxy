{ lib, ... }:
{
  # options are nested under `home` to avoid confusion with system level options
  options.nix-files.home = {
    user = lib.mkOption {
      description = "Which home-manager user configuration to use";
      type = lib.types.str;
    };

    host = lib.mkOption {
      description = "Which home-manager <user>@host configuration to use";
      type = lib.types.str;
    };

    flake = lib.mkOption {
      description = "Path to nix-files flake";
      type = lib.types.path;
    };
  };
}
