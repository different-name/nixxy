{ lib, config, ... }:
{
  options.dyad.nix.distributed-builds.enable = lib.mkEnableOption "distributed builds config";

  config = lib.mkIf config.dyad.nix.distributed-builds.enable {
    nix = {
      distributedBuilds = true;
      settings.builders-use-substitutes = true;

      buildMachines = lib.singleton {
        hostName = "sodium";
        sshUser = "remotebuild";
        sshKey = "/etc/ssh/ssh_host_ed25519_key";
        system = "x86_64-linux";

        supportedFeatures = [
          # keep-sorted start
          "big-parallel"
          "kvm"
          "nixos-test"
          # keep-sorted end
        ];
      };
    };
  };
}
