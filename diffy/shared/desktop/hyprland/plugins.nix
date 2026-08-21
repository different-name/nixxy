{
  lib,
  config,
  inputs,
  ...
}:
let
  src = inputs.split-monitor-workspaces;
in
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager =
      { pkgs, ... }:
      let
        series = lib.versions.majorMinor pkgs.hyprland.version;
      in
      {
        assertions = lib.singleton {
          assertion = lib.hasInfix "# ${series}." (builtins.readFile "${src}/hyprpm.toml");
          message = "split-monitor-workspaces has no pins for hyprland ${series}.x, point its flake input at release/${series}.x";
        };

        wayland.windowManager.hyprland = {
          plugins = lib.singleton (
            pkgs.hyprlandPlugins.mkHyprlandPlugin {
              pluginName = "split-monitor-workspaces";
              version = pkgs.hyprland.version;

              inherit src;

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
