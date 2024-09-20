{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

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
          partitionId = "wwn-0x50014ee2145675c9-part1";
          partitionPath = "/dev/disk/by-id/${partitionId}";
          mountpoint = "/tmp/${partitionId}";
        in ''
          mkdir -p "${mountpoint}"
          mount -t ext4 "${partitionPath}" "${mountpoint}"
          rsync "${source}" "${mountpoint}" -avh --delete --progress --exclude /persist/home/different/.cache
          udisksctl unmount -b "${partitionPath}"
          udisksctl power-off -b "${partitionPath}"
        '';
      })
    ];
  };

  ### required config

  networking = {
    hostName = "sodium";
    hostId = "9471422d";
  };

  environment.etc.machine-id.source = ./machine-id;

  programs.nh.flake = "/home/different/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
