{
  lib,
  config,
  ...
}: {
  options.nix-files.users.iodine.enable = lib.mkEnableOption "User iodine";

  config = lib.mkIf config.nix-files.users.iodine.enable {
    age.secrets."user-pass/iodine".file = ../../secrets/user-pass/iodine.age;

    users.users."iodine" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-pass/iodine".path;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmh/7dgdq32eSKcp6kwN28UF+PuyKJmvFRZKKUnyvf0 different@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFgR+CwgIILS4vhO1VFCZwpek+MKMlA/rWZbWpPnPwz iodine@iodine"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1" # phone
      ];

      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "libvirtd"
      ];
    };

    # access to the hostkey independent of impermanence activation
    age.identityPaths = [
      "/persist/home/iodine/.ssh/id_ed25519"
    ];
  };
}
