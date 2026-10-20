{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "openssh" ] {
  nixos = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    environment.perpetual.default = {
      dirs = [ "/root/.ssh" ];
      # not the whole dir, it would hide the sshd_config nixos writes before the mount
      files = map (key: "/etc/ssh/${key}") [
        "ssh_host_ed25519_key"
        "ssh_host_ed25519_key.pub"
        "ssh_host_rsa_key"
        "ssh_host_rsa_key.pub"
      ];
    };
  };

  home-manager.home.perpetual.default.dirs = [ ".ssh" ];
}
