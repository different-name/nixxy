{ bundleLib, self, ... }:
let
  port = 6065;
  httpsPort = 8443;
in
bundleLib.mkEnableModule [ "dyad" "services" "webdav" ] {
  nixos =
    { config, lib, ... }:
    let
      tailscale = lib.getExe config.services.tailscale.package;
    in
    {
      age.secrets."webdav/seedvault".file = self + /secrets/webdav/seedvault.age;

      services.webdav = {
        enable = true;
        environmentFile = config.age.secrets."webdav/seedvault".path;
        settings = {
          address = "127.0.0.1";
          inherit port;
          directory = "/var/lib/webdav";
          permissions = "CRUD";
          users = [
            {
              username = "{env}WEBDAV_USERNAME";
              password = "{env}WEBDAV_PASSWORD";
            }
          ];
        };
      };

      systemd.services.webdav.serviceConfig.StateDirectory = "webdav";

      # seedvault refuses cleartext http, tailscale serve gives it a trusted cert
      systemd.services.webdav-tailscale-serve = {
        after = [
          "tailscaled.service"
          "webdav.service"
        ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 10;
          ExecStart = "${tailscale} serve --bg --https=${toString httpsPort} http://127.0.0.1:${toString port}";
          ExecStop = "${tailscale} serve --https=${toString httpsPort} off";
        };
      };

      networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ httpsPort ];

      environment.perpetual.default.dirs = [
        "/var/lib/webdav"
      ];
    };
}
