{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.steam.launchOptions;
in {
  options.programs.steam.launchOptions = let
    gameOptions = {
      variables = lib.mkOption {
        type = lib.types.attrsOf (lib.types.coercedTo lib.types.int toString lib.types.str);
        default = {};
        description = "A set of environment variables to set";
        example = {
          PROTON_LOG = 1;
          PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/wivrn/comp_ipc";
        };
      };

      unsetVariables = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "A list of environment variables to unset";
        example = ["TZ"];
      };
    };
  in {
    enable = lib.mkEnableOption "Steam game launch option configuration, requires launch options to be set to `steam-game-wrapper %command%` in Steam";

    global = lib.mkOption {
      type = lib.types.submodule {
        options = gameOptions;
      };
      default = {};
      description = "Global Steam launch option configuration";
    };

    games = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = gameOptions;
      });
      default = {};
      description = "Per-game Steam launch option configuration";
    };
  };

  config.programs.steam = lib.mkIf cfg.enable {
    extraPackages = let
      generateExports = variables:
        variables
        |> lib.mapAttrsToList (k: v: ''export ${k}="${v}"'')
        |> lib.concatStringsSep "\n";

      generateUnsets = variables:
        variables
        |> map (v: "unset ${v}")
        |> lib.concatStringsSep "\n";

      globalEnv = ''
        ${generateUnsets cfg.global.unsetVariables}
        ${generateExports cfg.global.variables}
      '';

      gameEnvs =
        cfg.games
        |> lib.mapAttrsToList (game: options: ''
          ${lib.escapeShellArg game})
            ${generateUnsets options.unsetVariables}
            ${generateExports options.variables}
            ;;
        '')
        |> lib.concatStringsSep "\n";

      steam-game-wrapper = pkgs.writeShellApplication {
        name = "steam-game-wrapper";
        runtimeInputs = with pkgs; [
          libnotify
        ];
        text =
          builtins.readFile ./steam-game-wrapper.sh
          |> lib.replaceStrings [
            "# __GLOBAL_ENV__"
            "# __GAME_ENVS__"
          ] [
            globalEnv
            gameEnvs
          ];
      };
    in [steam-game-wrapper];
  };
}
