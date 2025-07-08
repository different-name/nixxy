{ config, self, ... }:
self.lib.mkUser
  {
    inherit config;
    username = "different";
    homeConfig = import ./home;
  }
  {
    users.users."different" = {
      isNormalUser = true;

      openssh.authorizedKeys.keys = [
        # keep-sorted start
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD different@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1" # phone
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
  }
