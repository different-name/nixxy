{config, ...}: {
  systemd.user.tmpfiles.rules = let
    inherit (config.home) username homeDirectory;
    vrwebhelper = "${homeDirectory}/.local/share/Steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/vrwebhelper";
    vrchatPictures = "${homeDirectory}/media/.steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat";
  in [
    # https://lvra.gitlab.io/docs/steamvr/quick-start/#optional-disable-steamvr-dashboard
    "f ${vrwebhelper} 0644 ${username} users -"

    # link vrchat pictures to pictures folder
    "L ${homeDirectory}/pictures/vrchat - - - - ${vrchatPictures}"
  ];
}
