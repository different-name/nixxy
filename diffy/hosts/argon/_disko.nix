{
  disko.devices = {
    disk."main" = {
      type = "disk";
      device = "/dev/vda";
      content = {
        type = "gpt";

        partitions = {
          # limine's bios stage 2
          bios = {
            priority = 1;
            size = "1M";
            type = "EF02";
          };

          boot = {
            priority = 2;
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          root = {
            priority = 3;
            size = "100%";
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
                  swap.swapfile.size = "2G";
                  mountpoint = "/.swapvol";
                };
              };
            };
          };
        };
      };
    };
  };
}
