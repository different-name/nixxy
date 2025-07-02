{
  lib,
  config,
  inputs,
  ...
}:
lib.nix-files.mkUser {
  inherit config;
  username = "iodine";

  content = {
    age.secrets."user-pass/iodine".file = inputs.self + /secrets/user-pass/iodine.age;

    users.users."iodine" = {
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-pass/iodine".path;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD different@potassium"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5oCKpegl9IQDVehuGxvlSJTIkHy9Xr7myC9l2KJg2r iodine@iodine"
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
    age.identityPaths = lib.mkIf config.nix-files.parts.system.agenix.enable [
      "/persist/home/iodine/.ssh/id_ed25519"
    ];
  };
}
