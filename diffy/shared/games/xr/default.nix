{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "xr" ] {
  nixos.systemd.user.targets.vr-session.description = "VR session";

  home-manager.keep.safe = {
    configDirs = [ "openvr" ];
    stateDirs = [ "OpenComposite" ];
  };
}
