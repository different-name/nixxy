{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nix-files.parts.desktop.extra-packages.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.nix-files.parts.desktop.extra-packages.enable {
    home.packages = with pkgs; [
      pavucontrol
      wl-clipboard
      libnotify
    ];

    nix-files.parts.system.persistence = {
      directories = [
        ".local/state/wireplumber" # audio settings
      ];
    };
  };
}
