{ lib, config, ... }:
{
  options.dyad.nix.build-host.enable = lib.mkEnableOption "distributed build host config";

  config = lib.mkIf config.dyad.nix.build-host.enable {
    users.users.remotebuild = {
      isNormalUser = true;
      createHome = false;
      group = "remotebuild";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUx2TZSI1O5UyBFunUi93OX5jWy1F0reCCrn9jaU+ij root@potassium"
      ];
    };

    users.groups.remotebuild = { };

    nix.settings.trusted-users = [ "remotebuild" ];
  };
}
