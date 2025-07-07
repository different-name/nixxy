{ lib, config, ... }:
{
  options.dyad.profiles.terminal.enable = lib.mkEnableOption "terminal profile";

  config = lib.mkIf config.dyad.profiles.terminal.enable {
    programs.mosh.enable = true;

    dyad = {
      programs.ephemeralTools.enable = true;

      services.tailscale.enable = true;

      theming.catppuccin.enable = true;
    };
  };
}
