{ lib, config, ... }:
{
  options.dyad.applications.kitty.enable = lib.mkEnableOption "kitty config";

  config = lib.mkIf config.dyad.applications.kitty.enable {
    programs.kitty = {
      enable = true;

      settings = {
        font_size = 11;
        window_padding_width = 6;
        placement_strategy = "top-left";
        cursor_trail = 3;
        cursor_trail_decay = "0.05 0.3";
      };
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/kitty"
      "$dataHome/kitty-ssh-kitten"
      # keep-sorted end
    ];
  };
}
