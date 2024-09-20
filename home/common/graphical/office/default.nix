{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.office.enable = lib.mkEnableOption "Office packages";

  config = lib.mkIf config.nix-files.graphical.office.enable {
    home.packages = with pkgs; [
      libreoffice-qt6-fresh
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/libreoffice"
      ];
    };
  };
}
