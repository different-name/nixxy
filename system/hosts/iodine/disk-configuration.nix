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
