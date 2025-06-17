{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.parts.desktop.extra-packages.enable = lib.mkEnableOption "extra wayland packages";

  config = lib.mkIf config.nix-files.parts.desktop.extra-packages.enable {
    home.packages = with pkgs; [
      pavucontrol
      wl-clipboard
      libnotify
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        # pavucontrol
        ".local/state/wireplumber" # audio settings
      ];
    };
  };
}
