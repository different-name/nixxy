{ lib, config, ... }:
{
  options.dyad.profiles.terminal.enable = lib.mkEnableOption "terminal profile";

  config = lib.mkIf config.dyad.profiles.terminal.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      programs = {
        distrobox.enable = true;
        epht.enable = true;
      };

      services.tailscale.enable = true;

      style.catppuccin.enable = true;
      # keep-sorted end
    };

    programs.mosh.enable = true;
  };
}
