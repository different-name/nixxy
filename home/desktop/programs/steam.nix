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
  # TODO there's likely a better way to do this
  home.activation.disableSteamDashboard = lib.hm.dag.entryAnywhere ''
    chmod -x ${config.home.homeDirectory}/.steam/steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/vrwebhelper
  '';
}
