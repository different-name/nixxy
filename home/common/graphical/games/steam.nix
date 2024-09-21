{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.games.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.graphical.games.steam.enable {
    systemd.user.tmpfiles.rules = let
      inherit (config.home) homeDirectory;
      vrchatPictures = "${homeDirectory}/media/.steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
    in [
      # link vrchat pictures to pictures folder
      "L ${homeDirectory}/pictures/vrchat - - - - ${vrchatPictures}"
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".local/share/TerraTech"
        ".local/share/aspyr-media/borderlands 2"
        ".factorio"
      ];
    };
  };
}
