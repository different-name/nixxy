let
  poolConfig = {
    type = "zpool";
    options = {
      ashift = "12"; # 4K sectors
      autotrim = "on";
    };
    rootFsOptions = {
      # https://www.medo64.com/2022/01/my-zfs-settings/

      compression = "zstd"; # Not as fast as lz4, but better compression, compression isn't usually the bottleneck anyway
      normalization = "formD"; # Normalize filename characters
      acltype = "posixacl"; # Enables use of posix acl
      xattr = "sa"; # Set linux extended attributes directly in inodes
      dnodesize = "auto"; # Enable support for larger metadata
      atime = "off"; # Don't record access time
      encryption = "aes-256-gcm"; # gcm is apparently fast
      keyformat = "passphrase";
      canmount = "off";
      mountpoint = "none";
    };
  };

  datasetConfig = {
    type = "zfs_fs";
    options = {
      canmount = "noauto"; # Only allow explicit mounting
      mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
    };
  };

  mkDataset = pool: dataset: mountpoint:
    {
      inherit mountpoint;
      postCreateHook = "zfs snapshot ${pool}/${dataset}@empty";
    }
    // datasetConfig;
in {
  disko.devices = {
    # main disk
    disk."main" = {
      device = "/dev/nvme0n1";
      type = "disk";

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

          swap = {
            size = "4G";
            content = {
              type = "swap";
              randomEncryption = true; # https://wiki.nixos.org/wiki/Swap
            };
          };

          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          };
        };
      };
    };
    zpool."rpool" =
      {
        rootFsOptions.keylocation = "prompt";
        datasets = {
          "root" = mkDataset "rpool" "root" "/";
          "nix" = mkDataset "rpool" "nix" "/nix";
          "persist" = mkDataset "rpool" "persist" "/persist";
          "home" = mkDataset "rpool" "home" "/home";

          # steam needs ~/.steam  and ~/.local/share/Steam to be regular folders or mounts
          # these folders cannot be symlinks or bind mounts, else steam will crash
          "steam" = mkDataset "rpool" "steam" "/home/different/.steam";
          "lssteam" = mkDataset "rpool" "lssteam" "/home/different/.local/share/Steam";
        };
      }
      // poolConfig;
  };

  fileSystems = {
    "/home".neededForBoot = true; # Workaround for zfs mounting after /home folders are created
    "/persist".neededForBoot = true; # Required for impermanence to work
  };

  systemd.tmpfiles.rules = [
    # correcting permissions for zfs datasets mounted within home directory
    "d /home/different/.steam 0755 different users -"
    "d /home/different/.local 0755 different users -"
    "d /home/different/.local/share 0755 different users -"
    "d /home/different/.local/share/Steam 0755 different users -"

    # setting up home directories with correct permissions for home-manager impermanence
    "d /persist/home/ 1777 root root -"
    "d /persist/home/different 0700 different users -"
  ];
}
