{ bundleLib, ... }:
let
  devices = {
    potassium = {
      id = "2NDFQOA-VZAD7DK-SGYNCDB-VTIPCXP-KX5IQFG-7X7GQ4C-UQKHMBS-BQHVPQQ";
      addresses = [ "tcp://100.95.66.11:22000" ];
    };
    sodium = {
      id = "WJRUC4Y-EOM26L3-VRV2UDH-4VDHGOI-UVK2TJZ-BQL5GU7-VLZJOLN-H6HRSAJ";
      addresses = [ "tcp://100.112.139.3:22000" ];
    };
  };

  peers = builtins.attrNames devices;

  staggered = {
    type = "staggered";
    params.maxAge = toString (30 * 24 * 60 * 60);
  };
in
bundleLib.mkEnableModule [ "dyad" "services" "syncthing" ] {
  nixos.networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 ];
  };

  home-manager =
    { pkgs, lib, ... }:
    let
      ignores = {
        "nixxy/.stignore" = ''
          (?d).direnv
          (?d)result
          (?d)result-*
        '';
        "Sync/.stignore" = ''
          (?d).direnv
          (?d).terraform
          (?d).venv
          (?d)__pycache__
          (?d)build
          (?d)dist
          (?d)node_modules
          (?d)result
          (?d)result-*
          (?d)target
          (?d)*.db-journal
          (?d)*.db-shm
          (?d)*.db-wal
          /ncg-tools/.data/archive
          /ncg-tools/.data/backups
          /ncg-tools/.data/browser-profiles
          /ncg-tools/apps/migration/.data
        '';
      };
    in
    {
      services.syncthing = {
        enable = true;
        overrideDevices = true;
        overrideFolders = true;

        settings = {
          options = {
            urAccepted = -1; # -1 declines usage reporting
            relaysEnabled = false;
            globalAnnounceEnabled = false;
            localAnnounceEnabled = false;
            natEnabled = false;
          };

          inherit devices;

          folders = {
            nixxy = {
              path = "~/nixxy";
              devices = peers;
              versioning = staggered;
            };

            sync = {
              path = "~/Sync";
              label = "Sync";
              devices = peers;
              versioning = staggered;
            };

            # no versioning, transcripts are large and rewritten constantly
            claude-projects = {
              path = "~/.claude/projects";
              label = "Claude Projects";
              devices = peers;
            };
          };
        };
      };

      home.perpetual.default.dirs = [
        ".local/state/syncthing"
        "Sync"
      ];

      # syncthing will not follow a symlinked .stignore, so write real files
      home.activation.syncthingIgnores = lib.hm.dag.entryAfter [ "writeBoundary" ] (
        lib.concatLines (
          lib.mapAttrsToList (
            rel: text: ''run install -Dm644 ${pkgs.writeText "stignore" text} "$HOME/${rel}"''
          ) ignores
        )
      );
    };
}
