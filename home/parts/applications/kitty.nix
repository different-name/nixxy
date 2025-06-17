{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.applications.kitty.enable = lib.mkEnableOption "kitty config";

  config = lib.mkIf config.nix-files.parts.applications.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        font_size = 11;
        window_padding_width = 6;
        placement_strategy = "top-left";
      };
    };

    nix-files.parts.system.persistence = {
      directories = [
        ".cache/kitty"
        ".local/share/kitty-ssh-kitten"
      ];
    };
  };
}
