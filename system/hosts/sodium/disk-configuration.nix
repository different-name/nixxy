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

                  # steam needs ~/.steam  and ~/.local/share/Steam to be regular folders or mounts
                  # these folders cannot be symlinks or bind mounts, else steam will crash
                  "steam" = {
                    mountOptions = ["compress=zstd:1" "noatime"];
                    mountpoint = "/home/different/.steam";
                  };
                  "lssteam" = {
                    mountOptions = ["compress=zstd:1" "noatime"];
                    mountpoint = "/home/different/.local/share/Steam";
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

  systemd.tmpfiles.rules = [
    # correcting permissions for subvolumes mounted within home directory
    "d /home/different/.steam 0755 different users -"
    "d /home/different/.local 0755 different users -"
    "d /home/different/.local/share 0755 different users -"
    "d /home/different/.local/share/Steam 0755 different users -"
  ];
}
