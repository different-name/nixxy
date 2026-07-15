{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "sodium-builder" ] {
  nixos = {
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "sodium";
          sshUser = "nix-builder";
          sshKey = "/root/.ssh/id_ed25519";
          protocol = "ssh-ng";
          system = "x86_64-linux";
          maxJobs = 3;
          speedFactor = 2;
          supportedFeatures = [
            "benchmark"
            "big-parallel"
            "kvm"
            "nixos-test"
          ];
          mandatoryFeatures = [ ];
        }
      ];
    };

    # trust sodium's host key so the nix daemon can offload non-interactively
    programs.ssh.knownHosts.sodium = {
      hostNames = [
        "sodium"
        "sodium.local"
      ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9oz3SDojEZqnsBoYXOjdMGzyz3ILY7Luvfw7sTFm3/ root@sodium";
    };
  };
}
