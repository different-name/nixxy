{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.wayland.rofi.enable = lib.mkEnableOption "Rofi config";

  config = lib.mkIf config.nix-files.graphical.wayland.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
  };
}
