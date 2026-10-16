{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "kdeconnect" ] {
  nixos.programs.kdeconnect.enable = true;

  home-manager = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # the package's xdg autostart starts a second daemon outside the home-manager unit
    xdg.configFile."autostart/org.kde.kdeconnect.daemon.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';

    home.perpetual.default.dirs = [
      "$configHome/kdeconnect"
    ];
  };
}
