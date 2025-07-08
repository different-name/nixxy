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
      };
    };

    home.persistence-wrapper.dirs = [
      # keep-sorted start
      ".cache/kitty"
      ".local/share/kitty-ssh-kitten"
      # keep-sorted end
    ];
  };
}
