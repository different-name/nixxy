{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.ephemeral-tools;
in {
  options.programs.ephemeral-tools = {
    enable = lib.mkEnableOption "Enable ephtools command, for finding new and stray files";

    exclude-paths = lib.mkOption {
      description = "Paths to always exclude from the \"new\" command search results";
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = let
    homeConfigurations = lib.attrValues config.home-manager.users;

    getHomeStorageDirs = userConf:
      userConf.home.persistence |> lib.attrNames |> map (path: path + userConf.home.homeDirectory);

    storageDirs =
      (homeConfigurations |> map getHomeStorageDirs |> lib.flatten)
      ++ lib.attrNames config.environment.persistence;

    persistenceConfigs =
      (homeConfigurations |> map (userConf: lib.attrValues userConf.home.persistence) |> lib.flatten)
      ++ (lib.attrValues config.environment.persistence);

    persistedDirData =
      persistenceConfigs
      |> map (config: config.directories)
      |> lib.flatten
      |> map (directory: {
        path = directory.dirPath;
        storagePath = directory.persistentStoragePath + directory.dirPath;
      });

    persistedFileData =
      persistenceConfigs
      |> map (config: config.files)
      |> lib.flatten
      |> map (file: {
        path = file.filePath;
        storagePath = file.persistentStoragePath + file.filePath;
      });

    persistedPathData = persistedDirData ++ persistedFileData;

    persistedPaths = map (data: data.path) persistedPathData;
    inStoragePaths = map (data: data.storagePath) persistedPathData;

    # always exclude /nix and virtual filesystems
    excludedPaths =
      [
        "/nix"
        "/proc"
        "/sys"
        "/dev"
      ]
      ++ cfg.exclude-paths;

    # paths that `ephtools stray` will search
    strayCmdSearch = lib.concatMapStringsSep " " lib.escapeShellArg storageDirs;

    mkExcludeOptions = excludePaths:
      excludePaths |> map (path: "-path ${lib.escapeShellArg path}") |> lib.concatStringsSep " -o ";

    # paths that `ephtools new` will exclude from search
    newExcludeOpts = mkExcludeOptions (persistedPaths ++ storageDirs ++ excludedPaths);

    # paths that `ephtools stray` will exclude from search
    strayExcludeOpts = mkExcludeOptions inStoragePaths;
  in {
    environment.systemPackages = lib.mkIf cfg.enable [
      (pkgs.writeShellApplication {
        name = "ephtools";
        runtimeInputs = [pkgs.findutils];
        text =
          builtins.readFile ./ephtools.sh
          |> lib.replaceStrings
          [
            "__STRAY_CMD_SEARCH__"
            "__NEW_EXCLUDE_OPTS__"
            "__STRAY_EXCLUDE_OPTS__"
          ]
          [
            strayCmdSearch
            newExcludeOpts
            strayExcludeOpts
          ];
      })
    ];
  };
}
