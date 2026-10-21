{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "xr" ] {
  nixos.systemd.user.targets.vr-session.description = "VR session";

  home-manager = { pkgs, ... }: {
    xdg.desktopEntries.vr-session = {
      name = "VR session";
      icon = "io.github.wivrn.wivrn";
      exec = toString (
        pkgs.writeShellScript "vr-session-toggle" ''
          systemctl=${lib.getExe' pkgs.systemd "systemctl"}
          notify=${lib.getExe pkgs.libnotify}

          if $systemctl --user -q is-active vr-session.target; then
            $systemctl --user stop vr-session.target
            $notify -t 3000 "VR session stopped"
          # the target alone doesn't wait for or fail with its services
          elif $systemctl --user start vr-session.target wivrn.service; then
            $notify -t 3000 "VR session started"
          else
            $notify -u critical "VR session failed to start"
          fi
        ''
      );
    };

    keep.safe = {
      configDirs = [ "openvr" ];
      stateDirs = [ "OpenComposite" ];
    };
  };
}
