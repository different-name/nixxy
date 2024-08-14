{pkgs, ...}: {
  # steam will fail on first install, with the error message
  # "Fatal Error: Failed to load steamui.so" relaunching appears
  # to fix the issue and steam will continue where it left off
  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      # add proton ge
      proton-ge-bin
      # proton ge with rtsp patch, for vrchat video players
      (proton-ge-bin.overrideAttrs (finalAttrs: {
        pname = "proton-ge-rtsp-bin";
        version = "GE-Proton9-10-rtsp13";
        src = pkgs.fetchzip {
          url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/GE-Proton9-10-rtsp13/GE-Proton9-10-rtsp13.tar.gz";
          hash = "sha256-jf1p33Kuqtriycf6gOw/IBdx/ts/P7PJd+pjxonAS/U=";
        };
      }))
    ];
  };

  systemd.user.tmpfiles.rules = [
    # link vrchat pictures to pictures folder
    "L /home/different/Pictures/VRChat - - - - /home/different/Media/.steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/Pictures/VRChat"
  ];

  # https://lvra.gitlab.io/docs/steamvr/quick-start/#optional-disable-steamvr-dashboard
  # TODO there's likely a better way to do this
  system.userActivationScripts.disableSteamDashboard = {
    text = ''
      chmod -x /home/different/.steam/steam/steamapps/common/SteamVR/bin/vrwebhelper/linux64/vrwebhelper
    '';
    deps = [];
  };
}
