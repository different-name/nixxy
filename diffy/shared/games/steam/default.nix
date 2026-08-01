{
  bundleLib,
  lib,
  inputs,
  inputs',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "games" "steam" ] {
  nixos = { pkgs, ... }: {
    programs.steam = {
      enable = true;

      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    environment.systemPackages = [
      pkgs.gamescope-wsi # gamescope hdr support
    ];

    hardware.steam-hardware.enable = true;
  };

  home-manager =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.steam-config-nix.homeModules.default
      ];

      programs.steam.config = {
        enable = true;
        onSteamRunning = "close";

        defaultCompatTool = pkgs.proton-ge-bin;
        desktopEntries.enable = true;

        apps = {
          # keep-sorted start block=yes newline_separated=yes
          "Cyberpunk 2077" = {
            id = 1091500;
            compatTool = pkgs.proton-ge-bin;

            launchOptions = {
              env.WINEDLLOVERRIDES = "winmm,version=n,b";
              args = [
                "--launcher-skip"
                "-skipStartScreen"
              ];
            };
          };

          "VRChat" = {
            id = 438100;
            compatTool = inputs'.nixpkgs-xr.packages.proton-rtsp-bin;

            launchOptions.env = {
              TZ = null;
              # launcher service, for the vrchat:// forward (games/vrcx)
              STEAM_COMPAT_LAUNCHER_SERVICE = "proton";
              # restore the glib tls backend the launcher service hides via GIO_MODULE_DIR=/nonexistent (else video breaks)
              GIO_EXTRA_MODULES = "/usr/lib/x86_64-linux-gnu/gio/modules:/usr/lib/i386-linux-gnu/gio/modules";
            };
          };

          "Warhammer 40k Darktide" = {
            id = 1361210;
            compatTool = pkgs.proton-ge-bin;

            launchOptions = {
              env.LD_PRELOAD = null;
              preHook = ''
                for i in "''${!game_command[@]}"; do
                  game_command[i]="''${game_command[i]//\/launcher\/Launcher.exe/\/binaries\/Darktide.exe}"
                done
              '';
            };
          };
          # keep-sorted end
        };

        nonSteamApps = {
          vintage-story = {
            name = "Vintage Story";
            target = pkgs.vintagestory;
          };
        };
      };

      home.file."Pictures/VRChat" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
        force = true;
      };

      systemd.user.services.steam-silent = {
        Unit = {
          Description = "Steam (silent autostart)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${lib.getExe osConfig.programs.steam.package} -silent";
          Restart = "no";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      home.perpetual.default.dirs = [
        ".steam"
        "$dataHome/Steam"

        ".factorio"
        "$dataHome/Terraria"
        "$dataHome/TerraTech"
      ];
    };
}
