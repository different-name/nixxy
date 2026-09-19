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
