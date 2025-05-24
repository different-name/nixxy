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
    dirListToPath = dirList: (lib.concatStringsSep "/" dirList);

    splitPath = paths:
      paths
      |> lib.concatMap (builtins.split "/")
      |> lib.filter (s: builtins.typeOf s == "string" && s != "");

    concatPaths = paths: let
      prefix = paths |> lib.head |> lib.hasPrefix "/" |> (s: lib.optionalString s "/");
      path = paths |> splitPath |> dirListToPath;
    in
      prefix + path;

    # create a list of each system persistence configuration's key data
    systemPersistenceKeyData = let
      # data from system's persistence configs
      persistenceData = builtins.attrValues config.environment.persistence;
    in
      map (
        persistenceConfig: let
          inherit (persistenceConfig) persistentStoragePath;
          # each file is a set, we only want the file path
          filePaths = map (file: file.filePath) persistenceConfig.files;
          # each directory is a set, we only want the dir path
          dirPaths = map (dir: dir.dirPath) persistenceConfig.directories;
          # paths to persisted files & directories
          paths = filePaths ++ dirPaths;
          # path in persistent storage
          persistentStoragePaths = map (path: concatPaths [persistentStoragePath path]) paths;
        in {
          inherit paths persistentStoragePaths persistentStoragePath;
        }
      )
      persistenceData;

    # get all users in home-manager config
    usernames = builtins.attrNames config.home-manager.users;

    # create a list of each home persistence configuration's key data
    homePersistenceKeyData = lib.flatten (map (
        username: let
          # user's home-manager config
          userData = config.home-manager.users.${username};
          # user's home directory
          homeDirectory = userData.home.homeDirectory;
          # data from user's persistence configs
          persistenceData = builtins.attrValues userData.home.persistence;
          # create a set containing the persistentStoragePath
          # and absolute paths to persisted files & directories
          keyData =
            map (
              persistenceConfig: let
                inherit (persistenceConfig) persistentStoragePath;
                # relative paths to persisted files & directories
                relativePaths = persistenceConfig.files ++ persistenceConfig.directories;
                # absolute paths to persisted files & directories
                paths = map (relativePath: concatPaths [homeDirectory relativePath]) relativePaths;
                # path in persistent storage
                persistentStoragePaths = map (relativePath: concatPaths [persistentStoragePath relativePath]) relativePaths;
              in {
                inherit paths persistentStoragePaths persistentStoragePath;
              }
            )
            persistenceData;
        in
          keyData
      )
      usernames);

    # combine data
    persistenceKeyData = systemPersistenceKeyData ++ homePersistenceKeyData;

    # always exclude /nix and virtual filesystems
    exclude-paths =
      [
        "/nix"
        "/proc"
        "/sys"
        "/dev"
      ]
      ++ cfg.exclude-paths;

    # generate strings for use in script

    searchPathsToStr = searchPaths:
      searchPaths
      |> map lib.escapeShellArg
      |> lib.concatStringsSep " ";

    searchPathsNew =
      searchPathsToStr ["/"];

    searchPathsStray =
      persistenceKeyData
      |> map (data: data.persistentStoragePath)
      |> searchPathsToStr;

    excludePathsToStr = excludePaths:
      excludePaths
      |> map (path: "-path ${lib.escapeShellArg path}")
      |> lib.concatStringsSep " -o ";

    excludePathsNew =
      persistenceKeyData
      |> map (data: data.paths ++ [data.persistentStoragePath] ++ exclude-paths)
      |> lib.flatten
      |> excludePathsToStr;

    excludePathsStray =
      persistenceKeyData
      |> map (data: data.persistentStoragePaths)
      |> lib.flatten
      |> excludePathsToStr;
  in {
    environment.systemPackages = lib.mkIf cfg.enable [
      (pkgs.writeShellApplication {
        name = "ephtools";
        runtimeInputs = [pkgs.findutils];
        text = ''
          display_help() {
            echo "Usage: ephtools <command> [search paths...]"
            echo
            echo "Commands:"
            echo "  new   - List new files & directories that are not yet persisted"
            echo "  stray - List stray files & directories that are in persistent storage, but are not in the persistence config"
            echo
            echo "Arguments:"
            echo "  search paths - Override the search directories with one or more absolute paths"
          }

          SEARCH_DIRS=""

          validate_directories() {
            local valid=true

            for path in "$@"; do
              if [ -d "$path" ]; then
                if [[ "$path" == /* ]]; then
                  SEARCH_DIRS+="$path "
                else
                  echo "Error: '$path' is not an absolute path"
                  valid=false
                fi
              else
                echo "Error: '$path' is not a valid directory"
                valid=false
              fi
            done

            if [ "$valid" = false ]; then
              exit 1
            fi
          }

          if [ "$#" -lt 1 ]; then
            display_help
            exit 1
          fi

          COMMAND=$1
          shift

          case "$COMMAND" in
            "new")
              validate_directories "$@"
              if [ "$SEARCH_DIRS" = "" ]; then
                find ${searchPathsNew} \( ${excludePathsNew} \) -prune -o -type f -print
              else
                IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
                find "${"\${dir_array[@]}"}" \( ${excludePathsNew} \) -prune -o -type f -print
              fi
              ;;
            "stray")
              validate_directories "$@"
              if [ "$SEARCH_DIRS" = "" ]; then
                find ${searchPathsStray} \( ${excludePathsStray} \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
              else
                IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
                find "${"\${dir_array[@]}"}" \( ${excludePathsStray} \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
              fi
              ;;
            *)
              echo "Error: Unknown command"
              echo
              display_help
              exit 1
              ;;
          esac
        '';
      })
    ];
  };
}
