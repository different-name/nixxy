{
  lib,
  config,
  inputs',
  ...
}:
{
  config = lib.mkIf config.dyad.games.xr.enable {
    nixos = {
      systemd.user.services.solarxr-input = {
        description = "SolarXR OpenXR bindings";
        after = [
          "wivrn.service"
          "slimevr-server.service"
        ];
        requires = [ "wivrn.service" ];
        wants = [ "slimevr-server.service" ];
        partOf = [ "wivrn.service" ];

        serviceConfig = {
          ExecStart = lib.getExe' inputs'.solarxr-cli.packages.solarxr-cli "solarxr-input";
          Restart = "on-failure";
        };
      };

      environment.systemPackages = [ inputs'.solarxr-cli.packages.default ];
    };

    home-manager.xdg.configFile."solarxr-input/config.json".text = lib.toJSON {
      action_profiles = {
        "/interaction_profiles/oculus/touch_controller" = {
          reset_yaw = {
            left = "/user/hand/left/input/y/click";
            double_click = true;
          };
          tracking_pause_toggle = {
            right = "/user/hand/right/input/b/click";
            double_click = true;
          };
        };
        "/interaction_profiles/valve/index_controller" = { };
        "/interaction_profiles/htc/vive_controller" = { };
        "/interaction_profiles/microsoft/motion_controller" = { };
      };
    };
  };
}
