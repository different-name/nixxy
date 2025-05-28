{
  disko.devices = {
    disk."main" = {
      type = "disk";
      device = "/dev/disk/by-diskseq/9";
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
              extraArgs = ["-f"]; # Override existing partition

              mountpoint = "/btrfs";
              mountOptions = ["compress=zstd:1" "noatime"];

              subvolumes = {
                # current root, is swapped out each boot
                "root/current" = {
                  mountOptions = ["noatime"];
                  mountpoint = "/";
                };

                "nix" = {
                  mountOptions = ["compress=zstd:1" "noatime"];
                  mountpoint = "/nix";
                };

                "persist" = {
                  mountOptions = ["compress=zstd:1" "noatime"];
                  mountpoint = "/persist";
                };

                "swap" = {
                  mountpoint = "/.swapvol";
                  swap = {
                    swapfile.size = "16G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/persist".neededForBoot = true; # Required for impermanence to work
  };
}
