{
  lib,
  config,
  osConfig,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.steam-config-nix.homeModules.default
  ];

  options.dyad.games.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.dyad.games.steam.enable {
    programs.steam.config = {
      enable = true;
      closeSteam = true;

      apps = {
        # keep-sorted start block=yes newline_separated=yes
        # cyberpunk 2077
        "1091500" = {
          launchOptions = pkgs.writeShellScriptBin "cyberpunk-wrapper" ''
            export WINEDLLOVERRIDES="winmm,version=n,b"
            exec "$@" -modded --launcher-skip -skipStartScreen
          '';
        };

        # warhammer 40k: darktide
        "1361210" = {
          compatTool = "proton_experimental";
          launchOptions = pkgs.writeShellScriptBin "darktide-wrapper" ''
            unset LD_PRELOAD

            args=()
            for arg in "$@"; do
              args+=( "''${arg//\/launcher\/Launcher.exe/\/binaries\/Darktide.exe}" )
            done

            exec "''${args[@]}"
          '';
        };

        # vrchat
        "438100" = {
          compatTool = "GE-Proton";
          launchOptions = pkgs.writeShellScriptBin "vrchat-wrapper" ''
            unset TZ
            export PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc"

            if [[ "$*" != *"--no-vr"* ]]; then
                export PROTON_ENABLE_WAYLAND=1
            fi

            exec "$@"
          '';
        };
        # keep-sorted end
      };
    };

    home.file."Pictures/VRChat" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
      force = true;
    };

    xdg.autostart.entries = lib.singleton (
      pkgs.makeDesktopItem {
        name = "steam-silent";
        destination = "/";
        desktopName = "Steam Silent";
        noDisplay = true;
        exec = "${lib.getExe osConfig.programs.steam.package} -silent";
      }
      + /steam-silent.desktop
    );

    home.perpetual.default.dirs = [
      ".steam"
      "$dataHome/Steam"

      ".factorio"
      "$dataHome/Terraria"
      "$dataHome/TerraTech"
    ];
  };
}
