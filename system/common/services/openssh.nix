{
  lib,
  config,
  ...
}: {
  options.nix-files.services.openssh.enable = lib.mkEnableOption "OpenSSH config";

  config = lib.mkIf config.nix-files.services.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    environment.persistence."/persist/system".files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
