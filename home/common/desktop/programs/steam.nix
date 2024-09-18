{config, ...}: {
  systemd.user.tmpfiles.rules = let
    inherit (config.home) homeDirectory;
    vrchatPictures = "${homeDirectory}/media/.steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
  in [
    # link vrchat pictures to pictures folder
    "L ${homeDirectory}/pictures/vrchat - - - - ${vrchatPictures}"
  ];
}
