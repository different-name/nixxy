{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.nix.distributed-builds.enable =
    lib.mkEnableOption "Distributed builds config";

  config = lib.mkIf config.nix-files.parts.nix.distributed-builds.enable {
    nix = {
      distributedBuilds = true;
      settings.builders-use-substitutes = true;

      buildMachines = [
        {
          hostName = "sodium";
          sshUser = "remotebuild";
          sshKey = "/etc/ssh/ssh_host_ed25519_key";
          system = "x86_64-linux";
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
          ];
        }
      ];
    };
  };
}
