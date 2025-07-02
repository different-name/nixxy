{ lib, ... }:
{
  options.nix-files.host = lib.mkOption {
    description = "Which NixOS host configuration to use";
    type = lib.types.str;
  };
}
