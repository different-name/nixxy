{
  lib,
  config,
  pkgs,
  ...
}:
let
  btrfsDir = "/btrfs";
  btrfsExe = lib.getExe pkgs.btrfs-progs;
in
{
  options.nix-files.parts.system.btrfs.enable = lib.mkEnableOption "btrfs config";

  config = lib.mkIf config.nix-files.parts.system.btrfs.enable {
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
          mkdir -p ${btrfsDir}
          mount -t btrfs -o subvol=/ ${config.fileSystems."/".device} ${btrfsDir}

          if [[ -e ${btrfsDir}/root/current ]]; then
            timestamp=$(date --date="@$(stat -c %Y ${btrfsDir}/root)" "+%Y-%m-%d_%H:%M:%S")
            mv ${btrfsDir}/root/current "${btrfsDir}/root/$timestamp"
          fi

          btrfs subvolume create ${btrfsDir}/root/current

          umount ${btrfsDir}
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
        script = ''
          set -euo pipefail

          delete_subvolume_recursively() {
            local subvol="$1"
            while IFS= read -r line; do
              delete_subvolume_recursively "${btrfsDir}/$line"
            done < <(${btrfsExe} subvolume list -o "$subvol" | cut -f 9- -d ' ')
            echo "Deleting subvolume: $subvol"
            ${btrfsExe} subvolume delete "$subvol"
          }

          # get list of archived subvolumes excluding 'current'
          mapfile -t subvols < <(find "${btrfsDir}/root" -mindepth 1 -maxdepth 1 -type d ! -name current)

          # extract timestamps and sort by date (oldest first)
          sorted_subvols=($(printf "%s\n" "''${subvols[@]}" | sort))
          total=''${#sorted_subvols[@]}

          # number of candidates for deletion
          candidates=$((total - ${toString keepMinNum}))
          if (( candidates <= 0 )); then
            exit 0
          fi

          now=$(date +%s)

          for (( i=0; i < candidates; i++ )); do
            subvol="''${sorted_subvols[i]}"
            basename=$(basename "$subvol")

            # replace '_' with ' ' for date parsing
            timestamp="''${basename/_/ }"

            # convert to epoch seconds
            if ! subvol_epoch=$(date -d "$timestamp" +%s 2>/dev/null); then
              echo "Error: Failed to parse timestamp from subvolume name '$basename'" >&2
              exit 1
            fi

            # calculate age in days
            age_days=$(( (now - subvol_epoch) / 86400 ))

            if (( age_days > ${toString keepAgeDays} )); then
              delete_subvolume_recursively "$subvol"
            fi
          done
        '';
      };

    services.fstrim.enable = true;
  };
}
