{
  lib,
  config,
  self,
  ...
}:
{
  options.dyad.users.diffy.enable = lib.mkEnableOption "user diffy";

  config = lib.mkIf config.dyad.users.diffy.enable {
    users.users.diffy = {
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-passwords/diffy".path;

      openssh.authorizedKeys.keys = [
        # keep-sorted start
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD diffy@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgwHkHZhWjbZdto1j13LZ2KU8CljqLsTkXYKHK4Qurc diffy@pico"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1 diffy@s23u"
        # keep-sorted end
      ];

      extraGroups = [
        # keep-sorted start
        "audio"
        "dialout"
        "i2c" # for dyad.hardware.ddcutil
        "input"
        "libvirtd"
        "networkmanager"
        "video"
        "wheel"
        # keep-sorted end
      ];
    };

    age = {
      secrets."user-passwords/diffy".file = self + /secrets/user-passwords/diffy.age;

      # access to the hostkey independent of impermanence activation
      identityPaths =
        let
          inherit (config.home-manager.users.diffy.home) persistence homeDirectory;
          persistentHomePath = persistence.default.persistentStoragePath + homeDirectory;
        in
        lib.singleton "${persistentHomePath}/.ssh/id_ed25519";
    };

    home-manager.users.diffy = {
      imports = [
        self.homeModules.dyad
      ];

      home = {
        username = "diffy";
        homeDirectory = "/home/diffy";
        inherit (config.system) stateVersion;
      };
    };
  };
}
