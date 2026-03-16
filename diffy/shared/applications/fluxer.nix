{
  bundleLib,
  lib,
  self',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "fluxer" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [
        self'.packages.fluxer
      ];

      xdg.autostart.entries = lib.singleton (
        (pkgs.makeDesktopItem {
          name = "fluxer";
          destination = "/";
          desktopName = "Fluxer";
          noDisplay = true;
          exec = lib.getExe self'.packages.fluxer;
        })
        + /fluxer.desktop
      );

      home.perpetual.default.dirs = [
        "$configHome/fluxer"
      ];
    };
}
