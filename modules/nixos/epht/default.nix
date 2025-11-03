{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.programs.epht;

  nixosConfigs = lib.filter (v: v.enable) (lib.attrValues config.environment.persistence);
  homeManagerConfigs =
    let
      paths = lib.flatten (
        lib.mapAttrsToList (
          _name: value: lib.attrValues (value.home.persistence or { })
        ) config.home-manager.users or { }
      );
    in
    lib.filter (v: v.enable) paths;

  allPersistentStoragePaths =
    let
      nixosUsers = lib.flatten (map lib.attrValues (lib.catAttrs "users" nixosConfigs));
    in
    lib.zipAttrsWith (_: v: lib.flatten v) (nixosConfigs ++ nixosUsers ++ homeManagerConfigs);

  inherit (allPersistentStoragePaths) files directories;

  storageDirs = lib.catAttrs "persistentStoragePath" (nixosConfigs ++ homeManagerConfigs);

  allNormalizedStoragePaths =
    let
      normalizePath = type: set: {
        paths = set."${type}Path";
        storagePaths = set.persistentStoragePath + set."${type}Path";
      };
      normalizedFiles = map (normalizePath "dir") directories;
      normalizedDirs = map (normalizePath "file") files;
    in
    lib.zipAttrsWith (_: v: lib.flatten v) (normalizedFiles ++ normalizedDirs);

  inherit (allNormalizedStoragePaths) paths storagePaths;

  mkExcludeOptions =
    excludePaths:
    excludePaths |> map (path: "-path ${lib.escapeShellArg path}") |> lib.concatStringsSep " -o ";
in
{
  options.programs.epht = {
    enable = lib.mkEnableOption "epht command, a utility for finding new and stray files";

    exclude-paths = lib.mkOption {
      description = "Paths to always exclude from the \"new\" command search results";
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfg.enable [
      (pkgs.writeShellApplication {
        name = "epht";
        runtimeInputs = [ pkgs.findutils ];
        text =
          lib.readFile
          <| pkgs.replaceVars ./epht.sh {
            # paths that `epht stray` will search
            stray_cmd_search = lib.concatMapStringsSep " " lib.escapeShellArg storageDirs;
            # paths that `epht new` will exclude from search
            new_exclude_opts = mkExcludeOptions (paths ++ storageDirs ++ cfg.exclude-paths);
            # paths that `epht stray` will exclude from search
            stray_exclude_opts = mkExcludeOptions storagePaths;
          };
      })
    ];
  };
}
