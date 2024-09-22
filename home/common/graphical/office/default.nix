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

    home.persistence = lib.mkIf config.nix-files.persistence.enable {
      "/persist${config.home.homeDirectory}" = {
        directories = [
          ".config/libreoffice"
        ];
      };

      "/persist${config.home.homeDirectory}-cache" = {
        directories = [
          ".config/libreoffice/4/cache"
          ".config/libreoffice/4/user/uno_packages/cache"
        ];
      };
    };
  };
}
