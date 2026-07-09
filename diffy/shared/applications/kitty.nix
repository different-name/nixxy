{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "kitty" ] {
  home-manager = {
    programs.kitty = {
      enable = true;

      settings = {
        font_size = 11;
        window_padding_width = 6;
        placement_strategy = "top-left";
        cursor_trail = 3;
        cursor_trail_decay = "0.05 0.3";
      };

      # ctrl+backspace -> ctrl+w (delete word)
      keybindings."ctrl+backspace" = "send_text all \\x17";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/kitty"
      "$dataHome/kitty-ssh-kitten"
    ];
  };
}
