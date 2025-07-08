{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  # accept generic types anything so that upstream handles typing instead
  # this is less maintenance in the event typing changes
  persistOptions = {
    dirs = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "directories to pass to persistence config";
    };
    files = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "files to pass to persistence config";
    };
  };

  cfg = config.dyad.system.persistence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.dyad.system.persistence = {
    enable = lib.mkEnableOption "persistence config";
    inherit (persistOptions) dirs files;

    installPkgsWithPersistence = lib.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              inherit (persistOptions) dirs files;
              package = lib.mkOption {
                type = types.package;
                default = pkgs.${name};
                description = "Package to install";
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config =
    let
      packageList = lib.attrValues cfg.installPkgsWithPersistence;

      directories = cfg.dirs ++ (lib.flatten <| map (value: value.dirs) packageList);
      files = cfg.files ++ (lib.flatten <| map (value: value.files) packageList);
    in
    lib.mkIf cfg.enable {
      home = {
        packages = map (value: value.package) packageList;
        persistence."/persist" = { inherit directories files; };
      };
    };
}
