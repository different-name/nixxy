{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "virt-manager" ] {
  nixos =
    {
      config,
      pkgs,
      utils,
      ...
    }:
    {
      programs.virt-manager.enable = true;

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          # tpm support
          swtpm.enable = true;
          # file sharing between host & guest
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      environment.perpetual.default = {
        dirs = [
          "/var/lib/libvirt"
          "/var/lib/swtpm-localca"
        ];
        # systemd-creds host key, else the encrypted libvirt secret breaks on reboot
        files = [ "/var/lib/systemd/credential.secret" ];
      };

      # impermanence symlinks missing persist files, but systemd-creds rejects a
      # symlinked host key, so generate a real one before impermanence runs
      systemd.services."seed-systemd-credential-secret" =
        let
          livePath = "/var/lib/systemd/credential.secret";
          persistPath = "/persist/system${livePath}";
          impermanenceUnit = "persist-${utils.escapeSystemdPath persistPath}.service";
        in
        {
          description = "Seed systemd credential host secret into persistent storage";
          wantedBy = [ impermanenceUnit ];
          before = [ impermanenceUnit ];
          unitConfig = {
            DefaultDependencies = false;
            ConditionPathExists = "!${persistPath}";
          };
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
          path = [
            config.systemd.package
            pkgs.coreutils
          ];
          script = ''
            set -eu
            mkdir -p /var/lib/systemd "$(dirname ${persistPath})"
            # clear stale symlink so systemd-creds writes a real file
            rm -f ${livePath}
            systemd-creds setup
            # 0400 or systemd-creds rejects it as writable
            install -Dm400 ${livePath} ${persistPath}
            # drop live copy so impermanence bind mounts the persisted one
            rm -f ${livePath}
          '';
        };
    };
}
