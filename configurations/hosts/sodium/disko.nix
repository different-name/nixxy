{
  disko.devices = {
    disk."main" = {
      type = "disk";
      device = "/dev/disk/by-diskseq/1";
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
