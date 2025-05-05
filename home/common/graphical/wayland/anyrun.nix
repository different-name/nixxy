{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  # TODO figure out if home-manger or fufexan module should be used
  disabledModules = ["programs/anyrun.nix"];

  options.nix-files.graphical.wayland.anyrun.enable = lib.mkEnableOption "Anyrun config";

  config = lib.mkIf config.nix-files.graphical.wayland.anyrun.enable {
    programs.anyrun = {
      enable = true;

      config = {
        plugins = with inputs.anyrun.packages.${pkgs.system}; [
          uwsm_app
          rink
          shell
          translate
        ];

        width.fraction = 0.25;
        y.fraction = 0.45;
        hidePluginInfo = true;
        closeOnClick = true;
      };

      extraConfigFiles = {
        "uwsm_app.ron".text = ''
          Config(
            desktop_actions: false,
            max_entries: 5,
          )
        '';

        "shell.ron".text = ''
          Config(
            prefix: ">"
          )
        '';

        "translate.ron".text = ''
          Config(
            prefix: ":",
            language_delimiter: ">",
            max_entries: 3,
          )
        '';
      };

      extraCss = ''
        #window {
          background: transparent;
        }
      '';
    };
  };
}
