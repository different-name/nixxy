{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "btrfs" ] {
  nixos =
    {
      config,
      pkgs,
      utils,
      ...
    }:
    let
      rootDevice = config.fileSystems."/".device;
      luksName = lib.removePrefix "/dev/mapper/" rootDevice;
      rootUnit =
        if config.boot.initrd.luks.devices ? ${luksName} then
          "systemd-cryptsetup@${luksName}.service"
        else
          "${utils.escapeSystemdPath rootDevice}.device";
    in
    {
      # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
      boot.initrd.systemd = {
        enable = true;
        services.root-subvol-switch = {
          description = "Switch btrfs root subvolume";
          wantedBy = [ "initrd.target" ];
          after = [ rootUnit ];
          requires = [ rootUnit ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            ROOT_DEVICE=${rootDevice}

            ${lib.readFile ./root-subvol-switch.sh}
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
              runtimeInputs = with pkgs; [ btrfs-progs ];
              text = ''
                KEEP_MIN_NUM=${toString keepMinNum}
                KEEP_AGE_DAYS=${toString keepAgeDays}

                ${lib.readFile ./root-subvol-cleanup.sh}
              '';
            }
          );
        };

      # single profile data, scrub detects rot but only repairs dup metadata
      services.btrfs.autoScrub.enable = true;

      services.fstrim.enable = true;

      services.btrbk = {
        instances."persist" = {
          onCalendar = "hourly";
          settings = {
            snapshot_preserve_min = "24h";
            snapshot_preserve = "48h 14d 8w";
            volume."/btrfs".subvolume = "persist";
          };
        };
      };
    };
}
