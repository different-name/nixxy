{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "extraPackages" ] {
  home-manager = { pkgs, lib, ... }: {
    imports = lib.attrValues {
      # keep-sorted start block=yes newline_separated=yes
      android-tools = {
        home.packages = [ pkgs.android-tools ];
        keep.safe.dirs = [ ".android" ];
      };

      emote = {
        home.packages = [ pkgs.emote ];
        keep.safe.dataDirs = [ "Emote" ];
      };

      ente = {
        home.packages = [ pkgs.ente-desktop ];
        keep.safe.configDirs = [ "ente" ];
      };

      gimp = {
        home.packages = [ pkgs.gimp3-with-plugins ];
        keep.safe = {
          cacheDirs = [ "gimp" ];
          configDirs = [ "GIMP" ];
        };
      };

      nrfconnect = {
        home.packages = [ pkgs.nrfconnect ];
        keep.safe = {
          dirs = [ ".nrfconnect-apps" ];
          configDirs = [ "nrfconnect" ];
        };
      };

      proton-pass = {
        home.packages = [ pkgs.proton-pass ];
        keep.safe.configDirs = [ "Proton Pass" ];
      };

      proton-vpn = {
        home.packages = [ pkgs.proton-vpn ];
        keep.safe = {
          cacheDirs = [ "Proton" ];
          configDirs = [ "Proton" ];
        };
      };

      qbittorrent = {
        home.packages = [ pkgs.qbittorrent ];
        keep.safe = {
          cacheDirs = [ "qBittorrent" ];
          configDirs = [ "qBittorrent" ];
          dataDirs = [ "qBittorrent" ];
        };
      };
      # keep-sorted end
    };

    home.packages = with pkgs; [
      # keep-sorted start
      pavucontrol
      qalculate-gtk
      scrcpy
      # keep-sorted end
    ];
  };
}
