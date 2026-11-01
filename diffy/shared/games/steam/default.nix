{
  bundleLib,
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (config.dyad.games.steam) autoStart;
in
bundleLib.mkEnableModule [ "dyad" "games" "steam" ] {
  options.autoStart = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Start Steam with the graphical session, hidden in the tray";
  };

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

  home-manager = { config, pkgs, ... }: {
    imports = [ inputs.steam-config-nix.homeModules.default ];

    programs.steam-config = {
      enable = true;
      onSteamRunning = "close";

      defaultCompatTool = pkgs.proton-ge-bin;
      desktopEntries.enable = true;

      apps."1282100" = {
        name = "Remnant II";

        # xwayland's screen spans both monitors, so wine won't confine the cursor without this
        files.prefix.writeKeys."user.reg" = {
          format = "registry";
          content."Software/Wine/X11 Driver".GrabFullscreen = "Y";
        };
      };
    };

    systemd.user.services.steam = lib.mkIf autoStart {
      Unit = {
        Description = "Steam";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        RefuseManualStart = true;
        RefuseManualStop = true;
      };

      Service = {
        ExecStart = "${config.programs.steam-config.launcher}/bin/steam -silent";
        Restart = "no";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    # re-downloadable, compatdata stays in persist for non-cloud saves
    keep.loose.dataDirs = [
      "Steam/steamapps/common"
      "Steam/steamapps/shadercache"
      "Steam/steamapps/workshop"
    ];

    keep.safe = {
      dirs = [
        ".steam"
        ".factorio"
      ];

      cacheDirs = [
        # keep-sorted start
        "mesa_shader_cache" # shader cache
        "protonfixes"
        "radv_builtin_shaders" # radv shader cache
        # keep-sorted end
      ];

      dataDirs = [
        # keep-sorted start
        "Steam"
        "TerraTech"
        "Terraria"
        "steam-config-nix"
        "umu" # proton runtime
        "vulkan" # steam fossilize and overlay layers
        # keep-sorted end
      ];
    };

    programs.keep.exclude = [
      # across the obelisk launcher
      ".local/share/Paradox Interactive"
      ".paradoxlauncher"
    ];
  };
}
