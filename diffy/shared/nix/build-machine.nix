{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "build-machine" ] {
  nixos = {
    users = {
      users.nix-builder = {
        isSystemUser = true;
        group = "nix-builder";
        useDefaultShell = true;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsxVRPHU7NetTLDygkO4QZJV7PUwwv17gPHqmTQpzzM root@potassium"
        ];
      };

      groups.nix-builder = { };
    };

    nix.settings.trusted-users = [ "nix-builder" ];
  };
}
