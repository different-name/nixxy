{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.steam.launchOptions;
in
{
  options.programs.steam.launchOptions =
    let
      gameOptions = {
        variables = lib.mkOption {
          type = lib.types.attrsOf (lib.types.coercedTo lib.types.int toString lib.types.str);
          default = { };
          description = "A set of environment variables to set";
          example = {
            PROTON_LOG = 1;
            PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/wivrn/comp_ipc";
          };
        };

        unsetVariables = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "A list of environment variables to unset";
          example = [ "TZ" ];
        };

        extraArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "A list of arguments to append to %command%";
          example = [ "--fps=60" ];
        };
      };
    in
    {
      enable = lib.mkEnableOption "steam game launch option configuration, requires launch options to be set to `steam-game-wrapper %command%` in steam";

      global = lib.mkOption {
        type = lib.types.submodule {
          options = gameOptions;
        };
        default = { };
        description = "Global Steam launch option configuration";
      };

      games = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = gameOptions;
          }
        );
        default = { };
        description = "Per-game Steam launch option configuration";
      };
    };

  config.programs.steam = lib.mkIf cfg.enable {
    extraPackages =
      let
        generateArgs = args: "( ${lib.concatStringsSep " " (map lib.escapeShellArg args)} )";

        generateExports =
          variables:
          variables |> lib.mapAttrsToList (k: v: ''export ${k}="${v}"'') |> lib.concatStringsSep "\n";

        generateUnsets = variables: variables |> map (v: "unset ${v}") |> lib.concatStringsSep "\n";

        globalOpts = ''
          EXTRA_ARGS+=${generateArgs cfg.global.extraArgs}
          ${generateUnsets cfg.global.unsetVariables}
          ${generateExports cfg.global.variables}
        '';

        gameOpts =
          cfg.games
          |> lib.mapAttrsToList (
            game: options: ''
              ${lib.escapeShellArg game})
                EXTRA_ARGS+=${generateArgs options.extraArgs}
                ${generateUnsets options.unsetVariables}
                ${generateExports options.variables}
                ;;
            ''
          )
          |> lib.concatStringsSep "\n";

        steam-game-wrapper = pkgs.writeShellApplication {
          name = "steam-game-wrapper";
          runtimeInputs = with pkgs; [
            libnotify
          ];
          text =
            builtins.readFile ./steam-game-wrapper.sh
            |>
              lib.replaceStrings
                [
                  "# __GLOBAL_OPTS__"
                  "# __GAME_OPTS__"
                ]
                [
                  globalOpts
                  gameOpts
                ];
        };
      in
      [ steam-game-wrapper ];
  };
}
