{
  inputs,
  pkgs,
  ...
}: let
  machine-id = "9471422d94d34bb8807903179fb35f11";
in {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ./fancontrol.nix

    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ### modules

  nix-files = {
    users.different.enable = true;

    profiles = {
      global.enable = true;
      graphical.enable = true;
    };

    hardware.nvidia.enable = true;

    services.xr.enable = true;

    services = {
      autologin = {
        enable = true;
        user = "different";
      };

      keyd.enable = true;
    };
  };

  ### host specific

  hardware.keyboard.qmk.enable = true;
  services.goxlr-utility.enable = true;

  environment = {
    sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
      GDK_SCALE = "2";
    };

    # script used to backup to external hdd
    systemPackages = [
      (pkgs.writeShellApplication {
        name = "runbackup";
        text = let
          source = "/persist";
          partitionId = "usb-Seagate_Expansion_Desk_2HC015KJ-0:0-part1";
          partitionPath = "/dev/disk/by-id/${partitionId}";
          mountpoint = "/tmp/${partitionId}";
        in ''
          mkdir -p "${mountpoint}"
          mount -t ext4 "${partitionPath}" "${mountpoint}"
          rsync "${source}" "${mountpoint}" -avh --delete --progress
          udisksctl unmount -b "${partitionPath}"
          udisksctl power-off -b "${partitionPath}"
        '';
      })
    ];
  };

  services.pipewire.wireplumber.connectPorts = [
    # mirror audio from goxlr outputs to wivrn output
    {
      output = {
        constraint = "GoXLR:monitor_*";
        leftAlias = "GoXLR:monitor_FL";
        rightAlias = "GoXLR:monitor_FR";
      };

      input = {
        constraint = "WiVRn:playback_*";
        leftAlias = "WiVRn:playback_1";
        rightAlias = "WiVRn:playback_2";
      };
    }
  ];

  ### required config

  networking = {
    hostName = "sodium";
    hostId = builtins.substring 0 8 machine-id;
  };

  environment.etc.machine-id.text = machine-id;

  programs.nh.flake = "/home/different/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
