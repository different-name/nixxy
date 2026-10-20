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
          extraLuaFiles.smw.content = ''
            package.path = package.path .. ";${src}/lua/?.lua"
            local smw = require("split-monitor-workspaces")
            smw.setup(${
              lib.generators.toLua { } {
                enable_persistent_workspaces = false;
                monitor_priority = [
                  "desc:BNQ BenQ EX3210U ETA5R01980SL0"
                  "desc:Microstep MAG 244F BC4H015300312"
                ];
              }
            })
            return smw
          '';

          settings.smw._var = lib.generators.mkLuaInline ''require("smw")'';
        };
      };
  };
}
