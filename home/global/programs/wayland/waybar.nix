{config, ...}: let
  hyprlandCfg = config.wayland.windowManager.hyprland;
  margin = hyprlandCfg.settings.general.gaps_out;
  marginStr = builtins.toString margin;
in {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
        ];
        modules-right = [
          "privacy"
          "systemd-failed-units"
          "mpris"
          "bluetooth"
          "tray"
          "clock"
        ];
        # margin = "${marginStr} ${marginStr} 0 ${marginStr}";
        spacing = margin;
        clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
        };

        # modules-left

        # modules-center

        # modules-right
        mpris = {
          format = "{dynamic}";
          format-paused = "<i>{dynamic}</i>";
          dynamic-order = [
            "title"
            "artist"
          ];
        };
        tray = {
          spacing = margin;
        };
        clock = {
          format = "{:%I:%M %p}";
          on-click = "";
        };
      };
    };

    # style = ''
    #   window#mainBar {
    #     padding: 5px;
    #   }
    # '';
  };
}
