{ bundleLib, inputs', ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "anyrun" ] {
  home-manager.programs.anyrun = {
    enable = true;
    package = inputs'.anyrun.packages.default;

    config = {
      plugins = with inputs'.anyrun.packages; [
        # keep-sorted start
        rink
        shell
        translate
        uwsm_app
        # keep-sorted end
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
}
