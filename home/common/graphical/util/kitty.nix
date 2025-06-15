{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.util.kitty.enable = lib.mkEnableOption "Kitty config";

  config = lib.mkIf config.nix-files.graphical.util.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        font_size = 11;
        window_padding_width = 6;
        placement_strategy = "top-left";
      };
    };

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/kitty"
        ".local/share/kitty-ssh-kitten"
      ];
    };
  };
}
