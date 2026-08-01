{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "brightness" ] {
  # osd is drawn by swayosd-server, so depend on it explicitly (not via the profile)
  dyad.desktop.swayosd.enable = true;

  # own the kernel-access deps so the module works standalone: i2c-* for ddc/ci,
  # and brightnessctl's udev rules (video group) for the /sys/class/backlight writes
  nixos =
    { pkgs, ... }:
    {
      hardware.i2c.enable = true;
      services.udev.packages = [ pkgs.brightnessctl ];
    };

  home-manager =
    { config, pkgs, ... }:
    let
      hyprland = config.wayland.windowManager.hyprland.package;

      probe = pkgs.writeShellApplication {
        name = "osd-brightness-probe";
        runtimeInputs = [
          pkgs.ddcutil
          pkgs.coreutils
        ];
        text = builtins.readFile ./osd-brightness-probe.sh;
      };

      watch = pkgs.writeShellApplication {
        name = "osd-brightness-watch";
        runtimeInputs = [
          probe
          pkgs.socat
          pkgs.coreutils
        ];
        text = builtins.readFile ./osd-brightness-watch.sh;
      };

      osd-brightness = pkgs.writeShellApplication {
        name = "osd-brightness";
        runtimeInputs = [
          hyprland # hyprctl
          probe # lazy-probe fallback
          pkgs.jq
          pkgs.brightnessctl # internal backlight
          pkgs.ddcutil
          pkgs.swayosd
          pkgs.systemd # busctl
          pkgs.util-linux # flock
          pkgs.coreutils
          pkgs.gawk
        ];
        text = builtins.readFile ./osd-brightness.sh;
      };
    in
    {
      # software gamma for external monitors without ddc/ci, idles at 1.0 until osd-brightness dims one
      systemd.user.services.wl-gammarelay-rs = {
        Unit = {
          Description = "wl-gammarelay-rs (per-output software gamma/brightness)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = lib.getExe' pkgs.wl-gammarelay-rs "wl-gammarelay-rs";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      # warm the backend cache at session start so the first keypress doesn't pay the probe latency
      systemd.user.services.osd-brightness-probe = {
        Unit = {
          Description = "Probe external monitors for DDC/CI (brightness backend cache)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = lib.getExe probe;
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      # keep that cache fresh across monitor hotplug
      systemd.user.services.osd-brightness-watch = {
        Unit = {
          Description = "Watch Hyprland monitor hotplug -> refresh brightness backend cache";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = lib.getExe watch;
          Restart = "always";
          RestartSec = 2;
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      home.packages = [
        osd-brightness
        probe
        watch
      ];
    };
}
