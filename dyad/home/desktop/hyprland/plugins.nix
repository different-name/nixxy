{
  lib,
  config,
  inputs',
  ...
}:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      plugins = [
        inputs'.hypr-split-monitor-workspaces.packages.split-monitor-workspaces
      ];

      settings.plugin = {
        split-monitor-workspaces = {
          monitor_priority = "desc:BNQ BenQ EX3210U ETA5R01980SL0, desc:Microstep MAG 244F BC4H015300312";
        };
      };
    };
  };
}
