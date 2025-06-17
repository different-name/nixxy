{ lib, ... }:
{
  options.nix-files.user = lib.mkOption {
    description = "home-manager config user";
    type = lib.types.str;
  };
}
