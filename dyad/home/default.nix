{ lib, ... }:
{
  options.dyad = {
    flake = lib.mkOption {
      description = "Path to flake";
      type = lib.types.path;
    };
  };
}
