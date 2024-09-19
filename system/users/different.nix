{
  lib,
  config,
  ...
}: {
  options.nix-files.users.different.enable = lib.mkEnableOption "User different";

  config = lib.mkIf config.nix-files.users.different.enable {
    age.secrets."user-pass/different".file = ../../secrets/user-pass/different.age;

    users.users."different" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-pass/different".path;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmh/7dgdq32eSKcp6kwN28UF+PuyKJmvFRZKKUnyvf0 different@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFgR+CwgIILS4vhO1VFCZwpek+MKMlA/rWZbWpPnPwz iodine@iodine"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1" # phone
      ];

      extraGroups = [
        "wheel"
        "audio"
        "video"
        "input"
        "networkmanager"
        "libvirtd"
      ];
    };

    # access to the hostkey independent of impermanence activation
    age.identityPaths = [
      "/persist/home/different/.ssh/id_ed25519"
    ];
  };
}
