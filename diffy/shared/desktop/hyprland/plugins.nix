{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager = { pkgs, ... }: {
      wayland.windowManager.hyprland = {
        plugins = lib.singleton (
          pkgs.hyprlandPlugins.mkHyprlandPlugin {
            pluginName = "split-monitor-workspaces";
            version = "1.2.0-unstable-2026-06-29";

            src = pkgs.fetchFromGitHub {
              owner = "zjeffer";
              repo = "split-monitor-workspaces";
              rev = "d6b45cdb9b30c388bc4ded4adad78a14e523d591";
              hash = "sha256-AIg6hxip9hP6XWIqpjQOIripCdJQvtKSEubV+qL8mF8=";
            };

            nativeBuildInputs = [
              pkgs.meson
              pkgs.ninja
            ];
            buildInputs = [ pkgs.lua ];

            meta = {
              homepage = "https://github.com/zjeffer/split-monitor-workspaces";
              description = "Hyprland plugin for dwm-like workspaces across monitors";
              license = lib.licenses.bsd3;
            };
          }
        );

        settings.plugin = {
          split-monitor-workspaces = {
            enable_persistent_workspaces = false;

            # TODO uncomment when fixed https://github.com/Duckonaut/split-monitor-workspaces/issues/246
            # monitor_priority = lib.concatStringsSep ", " [
            #   "desc:BNQ BenQ EX3210U ETA5R01980SL0"
            #   "desc:Microstep MAG 244F BC4H015300312"
            # ];
          };
        };
      };
    };
  };
}
