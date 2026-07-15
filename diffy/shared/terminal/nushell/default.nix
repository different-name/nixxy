{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "nushell" ] {
  nixos =
    { pkgs, ... }:
    {
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
            let theme = {
              text: "${colors.text.hex}"
              mauve: "${colors.mauve.hex}"
              lavender: "${colors.lavender.hex}"
              green: "${colors.green.hex}"
            }

            ${builtins.readFile ./config.nu}
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
