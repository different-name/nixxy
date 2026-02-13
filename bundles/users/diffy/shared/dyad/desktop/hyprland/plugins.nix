{
  lib,
  config,
  inputs',
  ...
}:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager.wayland.windowManager.hyprland = {
      plugins = [
        inputs'.hypr-split-monitor-workspaces.packages.split-monitor-workspaces
      ];

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
}
