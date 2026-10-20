{ bundleLib, self, ... }:
bundleLib.mkEnableModule [ "dyad" "users" "diffy" ] {
  dyad.system = {
    agenix.enable = true;
  };

  nixos = { config, lib, ... }: {
    users.users.diffy = {
      uid = 1000;
      isNormalUser = true;
      hashedPasswordFile = config.age.secrets."user-passwords/diffy".path;

      # not argon, a compromised server should not reach the desktops
      openssh.authorizedKeys.keys = with (import ../keys.nix).users.diffy; [
        lithium
        potassium
        sodium
      ];

      extraGroups = [
        # keep-sorted start
        "audio"
        "dialout"
        "input"
        "kvm"
        "networkmanager"
        "podman"
        "video"
        "wheel"
        # keep-sorted end
      ]
      ++ lib.optional config.hardware.i2c.enable config.hardware.i2c.group;
    };

    nix.settings.trusted-users = [ "diffy" ];

    age = {
      secrets."user-passwords/diffy".file = self + /diffy/secrets/user-passwords/diffy.age;
      inherit (config.home-manager.users.diffy.age) identityPaths;
    };
  };

  home-manager = { osConfig, ... }: {
    home = {
      username = "diffy";
      homeDirectory = "/home/diffy";
      inherit (osConfig.system) stateVersion;
    };
  };
}
