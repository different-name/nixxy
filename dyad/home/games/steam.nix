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
        # vrchat
        "438100" = {
          compatTool = "proton_experimental";
          launchOptions = ''env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc" %command%'';
        };

        # warhammer 40k: darktide
        "1361210" = {
          compatTool = "proton_experimental";
          launchOptions = ''LD_PRELOAD="" eval $( echo "%command%" | sed "s/\/launcher\/Launcher.exe'.*/\/binaries\/Darktide.exe'/" )'';
        };
      };
    };

    home.file."Pictures/VRChat" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
      force = true;
    };

    xdg.autostart.entries = [
      (
        (pkgs.makeDesktopItem {
          name = "steam-silent";
          destination = "/";
          desktopName = "Steam Silent";
          noDisplay = true;
          exec = "${lib.getExe osConfig.programs.steam.package} -silent";
        })
        + /steam-silent.desktop
      )
    ];

    home.perpetual.default.dirs = [
      ".steam"
      "$dataHome/Steam"

      ".factorio"
      "$dataHome/Terraria"
      "$dataHome/TerraTech"
    ];
  };
}
