{ lib, config, ... }:
{
  options.dyad.profiles.terminal.enable = lib.mkEnableOption "terminal profile";

  config = lib.mkIf config.dyad.profiles.terminal.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      programs.ephemeralTools.enable = true;

      services.tailscale.enable = true;

      theming.catppuccin.enable = true;
      # keep-sorted end
    };

    programs.mosh.enable = true;
  };
}
