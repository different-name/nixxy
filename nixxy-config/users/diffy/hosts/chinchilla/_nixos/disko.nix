{
  disko.devices = {
    disk."main" = {
      type = "disk";
      device = "/dev/sda";
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

          btrfs = {
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # override existing partition
              mountOptions = [
                "compress=zstd:1"
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
                    "compress=zstd:1"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };

                "persist" = {
                  mountOptions = [
                    "compress=zstd:1"
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
}
