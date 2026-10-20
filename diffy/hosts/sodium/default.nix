{ inputs, ... }: {
  dyad = {
    host = {
      machineId = "9471422d94d34bb8807903179fb35f11";
      stateVersion = "26.05";
    };

    users.diffy.enable = true;

    profiles.graphical.enable = true;

    services.backup.enable = true;

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

  };

  nixos = {
    imports = [
      (inputs.import-tree ./_nixos)
      inputs.nixos-hardware.nixosModules.common-cpu-amd
    ];

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
