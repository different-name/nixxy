{
  bundleLib,
  lib,
  inputs,
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

  home-manager = { osConfig, pkgs, ... }: {
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

          dllOverrides = {
            winmm = "n,b";
            version = "n,b";
          };
          args = [
            "--launcher-skip"
            "-skipStartScreen"
          ];
        };

        "Warhammer 40k Darktide" = {
          id = 1361210;
          compatTool = pkgs.proton-ge-bin;

          env.LD_PRELOAD = null;
          preHook = ''
            for i in "''${!game_command[@]}"; do
              game_command[i]="''${game_command[i]//\/launcher\/Launcher.exe/\/binaries\/Darktide.exe}"
            done
          '';
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

    systemd.user.services.steam-silent = {
      Unit = {
        Description = "Steam (silent autostart)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        X-SwitchMethod = "keep-old";
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
