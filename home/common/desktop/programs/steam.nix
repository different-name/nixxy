{
  config,
  lib,
  ...
}: {
  # link vrchat pictures to pictures folder
  systemd.user.tmpfiles.rules = [
    "L ${config.home.homeDirectory}/Pictures/VRChat - - - - ${config.home.homeDirectory}/Media/.steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat"
  ];

  # https://lvra.gitlab.io/docs/steamvr/quick-start/#optional-disable-steamvr-dashboard
  # TODO there's likely a better way to do this - probably with the tmpfiles rules above
  home.activation.disableSteamDashboard = let
    steamDashboard = "${config.home.homeDirectory}/.steam/steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/vrwebhelper";
  in
    lib.hm.dag.entryAnywhere ''
      if [ -d "${steamDashboard}" ]; then
        chmod -x ${steamDashboard}
      fi
    '';
}
