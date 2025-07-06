{ lib, ... }:
{
  options.dyad = {
    user = lib.mkOption {
      description = "Which home-manager user configuration to use";
      type = lib.types.str;
    };

    host = lib.mkOption {
      description = "Which home-manager <user>@host configuration to use";
      type = lib.types.str;
    };

    flake = lib.mkOption {
      description = "Path to flake";
      type = lib.types.path;
    };
  };
}
