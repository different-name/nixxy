{
  lib,
  inputs,
  self,
  ...
}:
let
  machineId = "9471422d94d34bb8807903179fb35f11";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles.graphical-extras.enable = true;

    applications.orca-slicer.enable = true;

    hardware.nvidia.enable = true;

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };

    nix.build-machine.enable = true;

    games = {
      xr.enable = true;
      avatar-tools.enable = true;
    };

    media.goxlr-utility.enable = true;

    services = {
      webdav.enable = true;
    };
  };

  nixos = {
    imports = [
      # keep-sorted start
      (inputs.import-tree ./_nixos)
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      self.nixosModules.tty1Autologin
      # keep-sorted end
    ];

    system.stateVersion = "26.05";

    networking = {
      hostName = "sodium";
      hostId = lib.substring 0 8 machineId;
    };

    environment.etc.machine-id.text = machineId;

    services = {
      tty1Autologin = {
        enable = true;
        user = "diffy";
      };
    };

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
      GDK_SCALE = "2";
    };

    programs.steam.gamescopeSession.args = [
      "-W"
      "3840"
      "-H"
      "2160"
      "-r"
      "144"
      "-f"
      "--hdr-enabled"
      "--prefer-output"
      "HDMI-A-1"
    ];
  };

  home-manager.programs.btop.settings.cpu_sensor = "k10temp/Tctl";
}
