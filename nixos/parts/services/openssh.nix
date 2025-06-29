{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.services.openssh.enable = lib.mkEnableOption "openssh config";

  config = lib.mkIf config.nix-files.parts.services.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    nix-files.parts.system.persistence = {
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];

      home.directories = [
        ".ssh"
      ];
    };
  };
}
