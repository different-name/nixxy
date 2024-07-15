{config ? {nix-files.user = "";}, ...}: let
  inherit (config.nix-files) user;
in {
  disko.devices = {
    disk."main" = {
      device = "/dev/mmcblk0";
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
    zpool."rpool" = {
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
        keylocation = "prompt";
        canmount = "off";
        mountpoint = "none";
      };

      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
          options = {
            canmount = "noauto"; # Only allow explicit mounting
            mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
          };
          postCreateHook = "zfs snapshot rpool/root@empty";
        };
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options = {
            canmount = "noauto"; # Only allow explicit mounting
            mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
          };
          postCreateHook = "zfs snapshot rpool/nix@empty";
        };
        persist = {
          type = "zfs_fs";
          mountpoint = "/persist";
          options = {
            canmount = "noauto"; # Only allow explicit mounting
            mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
          };
          postCreateHook = "zfs snapshot rpool/persist@empty";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
          options = {
            canmount = "noauto"; # Only allow explicit mounting
            mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
          };
          postCreateHook = "zfs snapshot rpool/home@empty";
        };
        # steam needs ~/.steam to be a regular folder or mount
        # this folder cannot be a symlink or bind mount, else
        # steam will crashcomplaining about steamwebhelper
        steam =
          {
            type = "zfs_fs";
            options = {
              canmount = "noauto"; # Only allow explicit mounting
              mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
            };
            postCreateHook = "zfs snapshot rpool/steam@empty";
          }
          // (
            if (user != "")
            then {
              mountpoint = "/home/${user}/.steam";
            }
            else {}
          );
        # steam needs ~/.local/share/Steam to be a regular folder or mount
        # this folder cannot be a symlink or bind mount, else
        # steam will crashcomplaining about steamwebhelper
        lssteam =
          {
            type = "zfs_fs";
            options = {
              canmount = "noauto"; # Only allow explicit mounting
              mountpoint = "legacy"; # Do not mount under the pool (/zpool/...)
            };
            postCreateHook = "zfs snapshot rpool/lssteam@empty";
          }
          // (
            if (user != "")
            then {
              mountpoint = "/home/${user}/.local/share/Steam";
            }
            else {}
          );
      };
    };
  };
  fileSystems."/home".neededForBoot = true; # Workaround for zfs mounting after /home folders are created
  fileSystems."/persist".neededForBoot = true; # Required for impermanence to work
}
