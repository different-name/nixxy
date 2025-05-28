{
  lib,
  config,
  ...
}: {
  options.nix-files.nix.build-host.enable = lib.mkEnableOption "Distributed build host config";

  config = lib.mkIf config.nix-files.nix.build-host.enable {
    users.users.remotebuild = {
      isNormalUser = true;
      createHome = false;
      group = "remotebuild";

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUx2TZSI1O5UyBFunUi93OX5jWy1F0reCCrn9jaU+ij root@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkkCK33jVJn/dSsrhc3zZIyzGZ6uaKwjIKCKyu0YVpm root@iodine"
      ];
    };

    users.groups.remotebuild = {};

    nix.settings.trusted-users = ["remotebuild"];
  };
}
