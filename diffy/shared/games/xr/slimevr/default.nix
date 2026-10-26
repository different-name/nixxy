{ lib, config, ... }:
let
  # the gui bundles slimevr-server, which builds from the gui's src
  patched =
    pkgs:
    let
      slimevr-server = pkgs.slimevr-server.override { inherit slimevr; };

      # patch src (not .patches) so slimevr-server gets it too
      slimevr = (pkgs.slimevr.override { inherit slimevr-server; }).overrideAttrs (old: {
        src = pkgs.applyPatches {
          inherit (old) src;
          patches = [
            (builtins.path {
              path = ./patches/launch-server-seperately.patch;
              name = "slimevr-launch-server-seperately";
            })
            (builtins.path {
              path = ./patches/force-standing-pose.patch;
              name = "slimevr-force-standing-pose";
            })
          ];
        };
      });
    in
    {
      inherit slimevr slimevr-server;
    };
in
{
  config = lib.mkIf config.dyad.games.xr.enable {
    nixos = { pkgs, ... }: {
      systemd.user.services.slimevr-server = {
        description = "SlimeVR Server";
        partOf = [ "vr-session.target" ];
        wantedBy = [ "vr-session.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe (patched pkgs).slimevr-server} run";
          # hold activating until the solarxr websocket is listening
          ExecStartPost = pkgs.writeShellScript "wait-slimevr" ''
            for _ in $(seq 1 100); do
              (exec 3<>/dev/tcp/127.0.0.1/21110) 2>/dev/null && exit 0
              sleep 0.1
            done
            exit 1
          '';
          Restart = "on-failure";
          # jvm exits 143 on sigterm
          SuccessExitStatus = 143;
        };
      };

      # slimevr server
      networking.firewall.allowedUDPPorts = [ 6969 ];

      # slimevr tracker udev rules
      services.udev.packages = [ (patched pkgs).slimevr ];

      keep.safe.dirs = [
        "/root/.config/dev.slimevr.SlimeVR"
        "/root/.local/share/dev.slimevr.SlimeVR"
      ];
    };

    home-manager = { pkgs, ... }: {
      home.packages = [ (patched pkgs).slimevr ];

      keep.safe = {
        cacheDirs = [ ".slimevr-wrapped_" ];
        configDirs = [ "dev.slimevr.SlimeVR" ];
        dataDirs = [
          ".slimevr-wrapped_"
          "dev.slimevr.SlimeVR"
        ];
      };
    };
  };
}
