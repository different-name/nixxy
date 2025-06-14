{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.steam-launch-nix.homeModules.steam-launch
  ];

  options.nix-files.graphical.games.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.graphical.games.steam.enable {
    programs.steam-launch = {
      enable = true;
      stopSteam = true;
      options = {
        "438100" = ''env -u TZ PRESSURE_VESSEL_FILESYSTEMS_RW="$XDG_RUNTIME_DIR/wivrn/comp_ipc" %command%'';
      };
    };

    systemd.user.tmpfiles.rules = let
      inherit (config.home) homeDirectory;
      vrchatPictures = "${homeDirectory}/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
    in [
      # link vrchat pictures to pictures folder
      "L ${homeDirectory}/Pictures/VRChat - - - - ${vrchatPictures}"
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".local/share/TerraTech"
        ".local/share/aspyr-media/borderlands 2"
        ".factorio"
        ".local/share/Terraria"
      ];
    };
  };
}
