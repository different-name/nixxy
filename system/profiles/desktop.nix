{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.desktop.enable = lib.mkEnableOption "Desktop profile";

  config = lib.mkIf config.nix-files.profiles.desktop.enable {
    hardware.graphics.enable = true;

    nix-files = {
      programs = {
        fonts.enable = true;
        hyprland.enable = true;
        qt.enable = true;
        steam.enable = true;
        thunar.enable = true;
        xdg.enable = true;
      };

      services = {
        pipewire.enable = true;
      };
    };
  };
}
