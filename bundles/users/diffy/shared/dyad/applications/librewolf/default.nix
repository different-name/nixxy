{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "librewolf" ] {
  home-manager = {
    programs.librewolf = {
      enable = true;

      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "librewolf.desktop";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/librewolf"
      ".librewolf"
    ];
  };
}
