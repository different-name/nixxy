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
        # electron only uses the keyring on desktops it recognises, hyprland isn't one
        home.packages = lib.singleton (pkgs.symlinkJoin {
            inherit (pkgs.ente-desktop) name meta;
            paths = [ pkgs.ente-desktop ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/ente-desktop --add-flags --password-store=gnome-libsecret
            '';
          });
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

      opencloud = {
        home.packages = [ pkgs.opencloud-desktop ];
        keep.safe.configDirs = [ "OpenCloud" ];
        # a synced folder lost on reboot would sync its deletion to the server
        keep.loose.dirs = [ "OpenCloud" ];
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
