{
  lib,
  config,
  self,
  ...
}: {
  options.nix-files.users.different.enable = lib.mkEnableOption "User different";

  config = lib.mkIf config.nix-files.users.different.enable {
    age.secrets."user-pass/different".file = "${self}/secrets/user-pass/different.age";

    users.users."different" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-pass/different".path;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD different@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5oCKpegl9IQDVehuGxvlSJTIkHy9Xr7myC9l2KJg2r iodine@iodine"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1" # phone
      ];

      extraGroups = [
        "wheel"
        "audio"
        "video"
        "input"
        "networkmanager"
        "libvirtd"
        "dialout"
      ];
    };

    home-manager.users."different" =
      import "${self}/home/users/different/hosts/${config.networking.hostName}.nix";

    # access to the hostkey independent of impermanence activation
    age.identityPaths = lib.mkIf config.nix-files.core.agenix.enable [
      "/persist/home/different/.ssh/id_ed25519"
    ];
  };
}
