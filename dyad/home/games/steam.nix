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

      apps."438100" = {
        compatTool = "proton_experimental";
        launchOptions = ''env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc" %command%'';
      };
    };

    systemd.user.tmpfiles.rules =
      let
        inherit (config.home) homeDirectory;
        vrchatPictures = "${homeDirectory}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
      in
      [
        # link vrchat pictures to pictures folder
        "L ${homeDirectory}/Pictures/VRChat - - - - ${vrchatPictures}"
      ];

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

    dyad.system.persistence = {
      directories = [
        ".steam"
        ".local/share/Steam"

        ".factorio"
        ".local/share/Terraria"
        ".local/share/TerraTech"
      ];
    };
  };
}
