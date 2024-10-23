{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.wayland.hyprlock.enable = lib.mkEnableOption "Hyprlock config";

  config = lib.mkIf config.nix-files.graphical.wayland.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      # package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = false;
          no_fade_in = true;
          no_fade_out = true;
        };

        background = [
          {monitor = "";}
        ];

        input-field = [
          {
            monitor = "eDP-1";

            size = "300, 50";

            outline_thickness = 1;

            outer_color = "rgb(ffffff)";
            inner_color = "rgb(ff0000)";
            font_color = "rgb(000000)";

            fade_on_empty = false;
            placeholder_text = ''<span>Password...</span>'';

            dots_spacing = 0.2;
            dots_center = true;
          }
        ];

        label = [
          {
            monitor = "";
            text = "$TIME";
            font_size = 50;
          }
        ];
      };
    };
  };
}
