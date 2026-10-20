{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "build-machine" ] {
  nixos = {
    users = {
      users.nix-builder = {
        isSystemUser = true;
        group = "nix-builder";
        useDefaultShell = true;

        openssh.authorizedKeys.keys = builtins.attrValues (import ../../keys.nix).users.root;
      };

      groups.nix-builder = { };
    };

    nix.settings.trusted-users = [ "nix-builder" ];
  };
}
