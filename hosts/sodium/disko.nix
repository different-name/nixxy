{
  disko.devices = {
    disk."main" = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-TEAM_TM8FPW004T_112409130300339";
      content = {
        type = "gpt";

        partitions = {
          ESP = {
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "rootfs";

              settings = {
                allowDiscards = true;
                keyFile = "/dev/disk/by-id/usb-USB_SanDisk_3.2Gen1_0101072cd798698d6112016d3dfc0ebdc692ee055cfa9fd65c515e148961c19d82360000000000000000000008299247008b1400a9558107642d3973-0:0";
                keyFileSize = 4096;
              };

              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # override existing partition
                mountOptions = [
                  "compress=lzo"
                  "noatime"
                ];
                mountpoint = "/btrfs";

                subvolumes = {
                  # current root, is swapped out each boot
                  "root/current" = {
                    mountOptions = [ "noatime" ];
                    mountpoint = "/";
                  };

                  "nix" = {
                    mountOptions = [
                      "compress=lzo"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };

                  "persist" = {
                    mountOptions = [
                      "compress=lzo"
                      "noatime"
                    ];
                    mountpoint = "/persist";
                  };

                  "swap" = {
                    swap.swapfile.size = "16G";
                    mountpoint = "/.swapvol";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
