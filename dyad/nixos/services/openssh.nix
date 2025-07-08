{ lib, config, ... }:
{
  options.dyad.services.openssh.enable = lib.mkEnableOption "openssh config";

  config = lib.mkIf config.dyad.services.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    environment.persistence-wrapper = {
      files = [
        # keep-sorted start
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        # keep-sorted end
      ];

      home.dirs = [
        ".ssh"
      ];
    };
  };
}
