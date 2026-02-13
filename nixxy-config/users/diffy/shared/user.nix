{
  lib,
  config,
  self,
  ...
}:
{
  options.dyad.users.diffy.enable = lib.mkEnableOption "user diffy";

  config = lib.mkIf config.dyad.users.diffy.enable {
    dyad.system = {
      home-manager.enable = true;
      agenix.enable = true;
    };

    nixos =
      { config, ... }:
      {
        users.users.diffy = {
          uid = 1000;
          isNormalUser = true;
          hashedPasswordFile = config.age.secrets."user-passwords/diffy".path;

          openssh.authorizedKeys.keys = [
            # keep-sorted start
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3EOgPFHT/t5cimzbfL/vEyolU4CbdT9HVMyp8PnTUG diffy@potassium"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1 diffy@s23u"
            # keep-sorted end
          ];

          extraGroups = [
            # keep-sorted start
            "audio"
            "dialout"
            "i2c" # for dyad.hardware.ddcutil
            "input"
            "kvm"
            "libvirtd"
            "networkmanager"
            "podman"
            "video"
            "wheel"
            # keep-sorted end
          ];
        };

        age = {
          secrets."user-passwords/diffy".file = self + /secrets/user-passwords/diffy.age;
          inherit (config.home-manager.users.diffy.age) identityPaths;
        };
      };

    hm =
      { osConfig, ... }:
      {
        home = {
          username = "diffy";
          homeDirectory = "/home/diffy";
          inherit (osConfig.system) stateVersion;
        };
      };
  };
}
