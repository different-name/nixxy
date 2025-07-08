{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.system.btrfs.enable = lib.mkEnableOption "btrfs config";

  config = lib.mkIf config.dyad.system.btrfs.enable {
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
  };
}
