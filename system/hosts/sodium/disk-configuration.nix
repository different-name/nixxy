{config ? {nix-files.user = "different";}, ...}: let
  inherit (config.nix-files) user;
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

  mkHomeDataset = pool: dataset: mountpoint:
    {
      postCreateHook = "zfs snapshot ${pool}/${dataset}@empty";
    }
    // (
      if (user != "")
      then {
        mountpoint = "/home/${user}/${mountpoint}";
      }
      else {}
    )
    // datasetConfig;
in {
  disko.devices = {
    # main disk
    disk."main" = {
      device = "/dev/disk/by-id/nvme-CT1000P2SSD8_2204E6020EF1";
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
          "steam" = mkHomeDataset "rpool" "steam" ".steam";
          "lssteam" = mkHomeDataset "rpool" "lssteam" ".local/share/Steam";
        };
      }
      // poolConfig;

    # extra disks
    disk."wd_blue_4tb_1" = {
      device = "/dev/disk/by-id/wwn-0x50014ee269371f8d";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "xpool";
            };
          };
        };
      };
    };
    disk."wd_blue_4tb_2" = {
      device = "/dev/disk/by-id/wwn-0x50014ee213e1860d";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "xpool";
            };
          };
        };
      };
    };
    zpool."xpool" =
      {
        rootFsOptions.keylocation = "file:///etc/zfs/keys/xpool.key";
        datasets."media" = mkHomeDataset "xpool" "media" "Media";
      }
      // poolConfig;
  };

  fileSystems."/home".neededForBoot = true; # Workaround for zfs mounting after /home folders are created
  fileSystems."/persist".neededForBoot = true; # Required for impermanence to work
}
