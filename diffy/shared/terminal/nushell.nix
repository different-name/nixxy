{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "nushell" ] {
  nixos =
    { pkgs, ... }:
    {
      # bash stays the POSIX login shell; drop into nushell for interactive use
      programs.bash.interactiveShellInit = ''
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          exec ${lib.getExe pkgs.nushell}
        fi
      '';
    };

  home-manager =
    { config, ... }:
    let
      catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
      colors = catppuccinPalette.${config.catppuccin.flavor}.colors;
    in
    {
      programs = {
        nushell = {
          enable = true;

          shellAliases = config.home.shellAliases;
          environmentVariables = config.home.sessionVariables;

          settings = {
            show_banner = false;
            edit_mode = "emacs";
          };

          extraConfig = lib.mkAfter ''
            $env.config.color_config.shape_internalcall = "${colors.text.hex}"
            $env.config.color_config.shape_external_resolved = "${colors.text.hex}"
            $env.config.color_config.shape_externalarg = "${colors.lavender.hex}"
            $env.config.color_config.shape_flag = "${colors.mauve.hex}"

            # stock nushell prompt, minus the right-side clock, path recolored mauve
            $env.PROMPT_COMMAND_RIGHT = ""
            $env.PROMPT_COMMAND = {||
                let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-dir }) {
                    null => $env.PWD
                    "" => "~"
                    $relative => ([~ $relative] | path join)
                }
                let path_color = (ansi { fg: "${colors.mauve.hex}" attr: b })
                let separator_color = (ansi { fg: "${colors.mauve.hex}" })
                let path_segment = $"($path_color)($dir)"
                $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
            }

            # green indicator, with a space between the path and the >
            $env.PROMPT_INDICATOR = $"(char space)(ansi { fg: "${colors.green.hex}" attr: b })> (ansi reset)"

            # carapace returns [] for positions it can't complete which suppresses nushell's file fallback
            # convert empty results to null so nushell completes files instead
            # fixes ffmpeg -i completion
            let carapace_completer = $env.config.completions.external.completer
            $env.config.completions.external.completer = {|spans|
                let result = (try { do $carapace_completer $spans } catch { null })
                if ($result | is-empty) { null } else { $result }
            }
          '';
        };

        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };
      };

      home.perpetual.default.dirs = [
        "$cacheHome/nushell"
        "$dataHome/nushell"
        "$configHome/nushell"
      ];
    };
}
