{
  config,
  lib,
  ...
}: let
  cfg = config.nix-files;
in {
  options.nix-files = {
    xDisplayScale = {
      enable = lib.mkOption {
        description = ''
          If enabled, fractional scaling will be passed to x applications
          through their respective environmental variables
        '';
        type = lib.types.bool;
        default = false;
      };

      value = lib.mkOption {
        description = ''
          Scaling value
        '';
        type = lib.types.str;
        default = "1";
      };
    };

    tools = {
      ephemeral = {
        enable = lib.mkOption {
          description = ''
            Enable ephemeral filesystem helper tools
          '';
          type = lib.types.bool;
          default = false;
        };

        exclude-paths = {
          home = lib.mkOption {
            description = ''
              List of home files / directories to exclude from fed & fedh
            '';
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          root = lib.mkOption {
            description = ''
              List of files / directories to exclude from fed
            '';
            type = lib.types.listOf lib.types.str;
            default = [];
          };
        };
      };
    };
  };

  config = let
    persistentStoragePaths = {
      home = config.home-manager.users.different.home.persistence;
      root = config.environment.persistence;
    };

    splitPath = paths: (
      lib.filter
      (s: builtins.typeOf s == "string" && s != "")
      (lib.concatMap (builtins.split "/") paths)
    );

    concatPaths = paths: let
      prefix = lib.optionalString (lib.hasPrefix "/" (lib.head paths)) "/";
      path = lib.concatStringsSep "/" (splitPath paths);
    in
      prefix + path;

    relativeToAbsHome = path: concatPaths ["/home/different" path];

    find = searchPaths: excludePaths: findOptions: let
      searchString = lib.concatMapStringsSep " " lib.escapeShellArg searchPaths;
      excludeString = lib.concatMapStringsSep " -o " (path: "-path " + (lib.escapeShellArg path)) excludePaths;
    in ''find ${searchString} \( ${excludeString} \) -prune -o ${findOptions} 2> /dev/null'';

    persisted-paths = {
      home = lib.flatten (map
        (
          persistentStoragePath: let
            persistentStorage = persistentStoragePaths.home.${persistentStoragePath};
          in
            map
            (
              relativePath: {
                path = relativeToAbsHome relativePath;
                persistPath = concatPaths [persistentStoragePath relativePath];
              }
            )
            (persistentStorage.files
              ++ persistentStorage.directories)
        )
        (lib.attrNames persistentStoragePaths.home));

      root = lib.flatten (map
        (
          persistentStoragePath: let
            persistentStorage = persistentStoragePaths.root.${persistentStoragePath};
          in
            map (
              path: {
                path = path;
                persistPath = concatPaths [persistentStoragePath path];
              }
            )
            ((map (file: file.file) persistentStorage.files)
              ++ (map (dir: dir.directory) persistentStorage.directories))
        )
        (lib.attrNames persistentStoragePaths.root));
    };
  in {
    environment.sessionVariables = lib.mkIf cfg.xDisplayScale.enable {
      STEAM_FORCE_DESKTOPUI_SCALING = cfg.xDisplayScale.value;
      GDK_SCALE = "2"; # TODO should be dynamic
    };

    environment.shellAliases = lib.mkIf cfg.tools.ephemeral.enable {
      # "find ephemeral directories" search root directory for unpersisted files / directories
      fed = let
        searchPaths = ["/"];
        excludePaths = cfg.tools.ephemeral.exclude-paths.root ++ (map relativeToAbsHome cfg.tools.ephemeral.exclude-paths.home) ++ (map (n: n.path) (persisted-paths.root ++ persisted-paths.home));
      in
        find searchPaths excludePaths "-type f -print";

      # "find ephemeral directories - home" only searches home directory
      fedh = let
        searchPaths = ["/home/different"];
        excludePaths = (map relativeToAbsHome cfg.tools.ephemeral.exclude-paths.home) ++ (map (n: n.path) persisted-paths.home);
      in
        find searchPaths excludePaths "-type f -print";

      # "find stray directories" find files in persistent storage that aren't being used
      fsd = let
        searchPaths = (lib.attrNames persistentStoragePaths.root) ++ (lib.attrNames persistentStoragePaths.home);
        excludePaths = map (path: path.persistPath) (persisted-paths.root ++ persisted-paths.home);
      in
        find searchPaths excludePaths ''\( -empty -type d -print \) -o \( -type f -print \)'';
    };
  };
}
