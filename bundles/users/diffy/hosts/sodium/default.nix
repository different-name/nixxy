{
  lib,
  inputs,
  self,
  self',
  ...
}:
let
  machineId = "9471422d94d34bb8807903179fb35f11";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles = {
      # keep-sorted start
      graphical-extras.enable = true;
      graphical.enable = true;
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    hardware.nvidia.enable = true;

    services = {
      keyd.enable = true;
      syncthing.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };
    games.xr.enable = true;
    media.goxlr-utility.enable = true;
  };

  nixos =
    { pkgs, ... }:
    {
      imports = [
        # keep-sorted start
        (inputs.import-tree ./_nixos)
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        self.nixosModules.tty1Autologin
        # keep-sorted end
      ];

      system.stateVersion = "24.05";

      networking = {
        hostName = "sodium";
        hostId = lib.substring 0 8 machineId;
      };

      environment.etc.machine-id.text = machineId;

      services.tty1Autologin = {
        enable = true;
        user = "diffy";
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

      hardware.brillo.enable = true; # backlight control
      services.goxlr-utility.enable = true;

      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_17;

        authentication = pkgs.lib.mkOverride 10 ''
          #type database DBuser origin-address auth-method
          local all      all     trust
          host  all      all     127.0.0.1/32   trust
        '';
      };
    };

  home-manager = {
    programs.btop.settings.cpu_sensor = "k10temp/Tctl";

    home.packages = [
      (self'.packages.btrbk-backup.override {
        backupConfig = {
          backupDiskUuid = "a5091625-835c-492f-8d99-0fc8d27012a0";
          cryptName = "backup_drive";
          mountPoint = "/mnt/backup";
          configPath = "/etc/btrbk/persist.conf";
        };
      })
      # pkgs.qmk TODO uncomment when fixed: https://github.com/nixos/nixpkgs/issues/472891
    ];
  };
}
