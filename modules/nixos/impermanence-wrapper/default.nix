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
      type = types.listOf types.anything;
      default = [ ];
      description = "directories to pass to persistence config";
    };
    files = lib.mkOption {
      type = types.listOf types.anything;
      default = [ ];
      description = "files to pass to persistence config";
    };
  };

  cfg = config.environment.persistence-wrapper;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.environment.persistence-wrapper = {
    inherit (persistOptions) dirs files;
    enable = lib.mkEnableOption "persistence wrapper, an Impermanence wrapper with a different configuration style";

    persistentStorage = lib.mkOption {
      type = types.str;
      description = "Path to persistent storage directory";
      example = "/persist";
    };

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

    home = { inherit (persistOptions) dirs files; };
  };

  config =
    let
      packageList = lib.attrValues cfg.installPkgsWithPersistence;

      directories = cfg.dirs ++ (lib.flatten <| map (value: value.dirs) packageList);
      files = cfg.files ++ (lib.flatten <| map (value: value.files) packageList);
    in
    lib.mkIf cfg.enable {
      environment = {
        systemPackages = map (value: value.package) packageList;
        persistence.${cfg.persistentStorage} = { inherit directories files; };
      };

      home-manager.sharedModules = lib.singleton {
        home.persistence-wrapper = {
          inherit (cfg.home) dirs files;
        };
      };
    };
}
