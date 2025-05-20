{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  options.nix-files.services.xr.enable = lib.mkEnableOption "XR config";

  config = lib.mkIf config.nix-files.services.xr.enable {
    services.wivrn = {
      enable = true;
      package = self.packages.${pkgs.system}.wivrn-solarxr;

      openFirewall = true;
      defaultRuntime = true;

      config = {
        enable = true;
        json = {
          bitrate = let
            Mbps = 100;
          in
            Mbps * 1000000;
        };
      };
    };

    # slimevr server
    networking.firewall.allowedUDPPorts = [6969];

    systemd.user.services = {
      slimevr-server = {
        description = "SlimeVR Server";
        partOf = ["vr-session.service"];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.slimevr-server} run";
          Restart = "on-failure";
        };

        wantedBy = ["default.target"];
      };

      wait-for-slimevr-server = {
        description = "Wait for SlimeVR Server to be ready";
        after = ["slimevr-server.service"];
        requires = ["slimevr-server.service"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${lib.getExe pkgs.bash} -c 'timeout 15s journalctl --user -fu slimevr-server.service | grep -m1 "\[SolarXR Bridge\] Socket /run/user/1000/SlimeVRRpc created"'
          '';
        };

        wantedBy = ["default.target"];
      };

      # extends the service provided by services.wivrn
      # https://github.com/NixOS/nixpkgs/blob/adaa24fbf46737f3f1b5497bf64bae750f82942e/nixos/modules/services/video/wivrn.nix#L183-L213
      wivrn = {
        after = ["wait-for-slimevr-server.service"];
        requires = ["wait-for-slimevr-server.service"];
        partOf = ["vr-session.service"];
      };

      wait-for-wivrn = {
        description = "Wait for Wivrn to be ready";
        after = ["wivrn.service"];
        requires = ["wivrn.service"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''
            ${lib.getExe pkgs.bash} -c 'timeout 15s journalctl --user -fu wivrn.service | grep -m1 "Service published: ${config.networking.hostName}" && sleep 0.5'
          '';
        };

        wantedBy = ["default.target"];
      };

      wlx-overlay-s = {
        description = "wlx-overlay-s";
        after = ["wait-for-wivrn.service"];
        requires = ["wait-for-wivrn.service"];
        partOf = ["vr-session.service"];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wlx-overlay-s} --openxr --replace";
          Restart = "on-failure";
          ExecStopSignal = "SIGKILL";
          KillSignal = "SIGKILL";
          SendSIGKILL = "yes";
          TimeoutStopSec = "1s";
        };

        wantedBy = ["default.target"];
      };

      vr-session = {
        description = "VR session meta service";
        after = [
          "slimevr-server.service"
          "wivrn.service"
          "wlx-overlay-s.service"
        ];
        wants = [
          "slimevr-server.service"
          "wivrn.service"
          "wlx-overlay-s.service"
        ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/true";
          RemainAfterExit = "yes";
        };

        wantedBy = ["default.target"];
      };
    };

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/root/.config/dev.slimevr.SlimeVR"
        "/root/.local/share/dev.slimevr.SlimeVR"
      ];
    };
  };
}
