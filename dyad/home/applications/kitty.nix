{ lib, config, ... }:
{
  options.dyad.applications.kitty.enable = lib.mkEnableOption "kitty config";

  config = lib.mkIf config.dyad.applications.kitty.enable {
    programs.kitty = {
      enable = true;

      settings = {
        font_size = 11;
        window_padding_width = 6;
      };

      extraConfig = ''
        ${lib.optionalString config.programs.tmux.enable ''
          shell ${lib.getExe config.programs.tmux.package}
        ''}
      '';
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/kitty"
      "$dataHome/kitty-ssh-kitten"
      # keep-sorted end
    ];
  };
}
