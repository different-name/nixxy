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
      userConf.home.persistence
      |> lib.attrNames
      |> map (path: path + userConf.home.homeDirectory);

    storageDirs =
      (
        homeConfigurations
        |> map getHomeStorageDirs
        |> lib.flatten
      )
      ++ lib.attrNames config.environment.persistence;

    persistenceConfigs =
      (
        homeConfigurations
        |> map (userConf: lib.attrValues userConf.home.persistence)
        |> lib.flatten
      )
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
      excludePaths
      |> map (path: "-path ${lib.escapeShellArg path}")
      |> lib.concatStringsSep " -o ";

    # paths that `ephtools new` will exclude from search
    newExcludeOpts = mkExcludeOptions (persistedPaths ++ storageDirs ++ excludedPaths);

    # paths that `ephtools stray` will exclude from search
    strayExcludeOpts = mkExcludeOptions inStoragePaths;
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
                find / \( ${newExcludeOpts} \) -prune -o -type f -print
              else
                IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
                find "${"\${dir_array[@]}"}" \( ${newExcludeOpts} \) -prune -o -type f -print
              fi
              ;;
            "stray")
              validate_directories "$@"
              if [ "$SEARCH_DIRS" = "" ]; then
                find ${strayCmdSearch} \( ${strayExcludeOpts} \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
              else
                IFS=' ' read -r -a dir_array <<< "$SEARCH_DIRS"
                find "${"\${dir_array[@]}"}" \( ${strayExcludeOpts} \) -prune -o \( -empty -type d -print \) -o \( -type f -print \)
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
