{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.dyad.system.btrfs;
in
{
  options.dyad.system.btrfs = {
    enable = lib.mkEnableOption "btrfs config";

    backup-script = {
      enable = lib.mkEnableOption "btrfs config";

      backup-disk-uuid = lib.mkOption {
        type = types.str;
        description = "UUID of disk to perform backup to";
        example = "a5091625-835c-492f-8d99-0fc8d27012a0";
      };

      crypt-name = lib.mkOption {
        type = types.str;
        description = "cryptsetup device name";
        example = "backup_drive";
      };

      mount = lib.mkOption {
        type = types.path;
        description = "path to mount backup drive, will check here for existing mount";
        example = "/mnt/backup";
      };

      subvolume = lib.mkOption {
        type = types.str;
        description = "subvolume to backup";
        example = "/btrfs/persist";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
    boot.initrd.systemd = {
      enable = true;
      services.root-subvol-switch = {
        description = "Switch btrfs root subvolume";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "systemd-cryptsetup@rootfs.service"
        ];
        requires = [
          "systemd-cryptsetup@rootfs.service"
        ];
        before = [
          "sysroot.mount"
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          ROOT_DEVICE=${config.fileSystems."/".device}

          ${builtins.readFile ./root-subvol-switch.sh}
        '';
      };
    };

    # based on https://github.com/tejing1/nixos-config/blob/46e31a56242d1aee21a4ef9095946f32564e8181/nixosConfigurations/tejingdesk/optin-state.nix#L67-L92
    # and https://github.com/nix-community/impermanence/blob/4b3e914cdf97a5b536a889e939fb2fd2b043a170/README.org?plain=1#L120-L126
    systemd.services.root-subvol-cleanup =
      let
        keepMinNum = 5;
        keepAgeDays = 30;
      in
      {
        description = "Btrfs root subvolume cleaner";
        startAt = "daily";
        serviceConfig.ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "root-subvol-cleanup";
            runtimeInputs = with pkgs; [
              btrfs-progs
            ];
            text = ''
              KEEP_MIN_NUM=${toString keepMinNum}
              KEEP_AGE_DAYS=${toString keepAgeDays}

              ${builtins.readFile ./root-subvol-cleanup.sh}
            '';
          }
        );
      };

    services.fstrim.enable = true;

    environment.systemPackages = lib.mkIf cfg.backup-script.enable [
      (pkgs.writeShellApplication {
        name = "btrfs-backup";
        runtimeInputs = with pkgs; [
          cryptsetup
          btrfs-progs
          pv
          udisks
        ];

        text = ''
          UUID="${cfg.backup-script.backup-disk-uuid}"
          CRYPT_NAME="${cfg.backup-script.crypt-name}"
          MOUNT_POINT="${cfg.backup-script.mount}"
          SNAPSHOT_DIR="${builtins.dirOf cfg.backup-script.subvolume}"
          SOURCE_SUBVOL="${cfg.backup-script.subvolume}"

          ${builtins.readFile ./btrfs-backup.sh}
        '';
      })
    ];
  };
}
