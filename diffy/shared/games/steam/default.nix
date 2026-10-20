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
    imports = [ inputs.steam-config-nix.homeModules.default ];

    programs.steam.config = {
      enable = true;
      onSteamRunning = "close";

      defaultCompatTool = pkgs.proton-ge-bin;
      desktopEntries.enable = true;

      apps."1282100" = {
        name = "Remnant II";

        # xwayland's screen spans both monitors, so wine won't confine the cursor without this
        files.prefix.patch."user.reg" = {
          format = "registry";
          content."Software/Wine/X11 Driver".GrabFullscreen = "Y";
        };
      };
    };

    systemd.user.services.steam-silent = {
      Unit = {
        Description = "Steam (silent autostart)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        RefuseManualStart = true;
        RefuseManualStop = true;
      };

      Service = {
        ExecStart = "${lib.getExe osConfig.programs.steam.package} -silent";
        Restart = "no";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    # re-downloadable, compatdata stays in default for non-cloud saves
    home.perpetual.volatile.dirs = [
      "$dataHome/Steam/steamapps/common"
      "$dataHome/Steam/steamapps/shadercache"
      "$dataHome/Steam/steamapps/workshop"
    ];

    home.perpetual.default.dirs = [
      ".steam"
      "$dataHome/Steam"
      "$cacheHome/protonfixes"

      ".factorio"
      "$dataHome/Terraria"
      "$dataHome/TerraTech"
    ];
  };
}
