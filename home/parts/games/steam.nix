{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.steam-launch-nix.homeModules.steam-launch
  ];

  options.nix-files.parts.games.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.parts.games.steam.enable {
    programs.steam-launch = {
      enable = true;
      stopSteam = true;
      options = {
        "438100" = ''env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc" %command%'';
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

    nix-files.parts.system.persistence = {
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
