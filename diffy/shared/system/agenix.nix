{
  bundleLib,
  lib,
  inputs,
  inputs',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "agenix" ] {
  nixos = { config, ... }: {
    imports = [ inputs.agenix.nixosModules.default ];

    # access to the hostkey independent of keep activation
    age.identityPaths = [ "${config.keep.safe.path}/system/etc/ssh/ssh_host_ed25519_key" ];

    environment.systemPackages = [ inputs'.agenix.packages.agenix ];
  };

  home-manager = { config, ... }: {
    imports = [ inputs.agenix.homeManagerModules.default ];

    # the home volume only exists once a module declares into it
    age.identityPaths = lib.mkIf (config.keep ? safe) [
      "${config.keep.safe.path}${config.home.homeDirectory}/.ssh/id_ed25519"
    ];
  };
}
