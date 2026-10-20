{
  bundleLib,
  config,
  lib,
  ...
}:
let
  inherit (config.dyad.desktop.hyprland) rounding;
  withHyprland = config.dyad.desktop.hyprland.enable;
in
bundleLib.mkEnableModule [ "dyad" "desktop" "mako" ] {
  home-manager =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      borderColor = lib.removePrefix "#" config.dyad.palette.green.hex;
    in
    {
      services.mako = {
        enable = true;
        settings = {
          "border-color" = lib.mkForce "#${borderColor}";
          "border-radius" = rounding;

          "mode=do-not-disturb" = {
            invisible = 1;
          };
        };
      };

      # toggles with a hyprctl notification, bound in hyprland
      home.packages = lib.mkIf withHyprland (
        lib.singleton (
          pkgs.writeShellApplication {
            name = "mako-dnd";

            runtimeInputs = [
              config.services.mako.package
              osConfig.programs.hyprland.package
            ];

            text = ''
              if makoctl mode | grep -q '\<do-not-disturb\>'; then
                  makoctl mode -r do-not-disturb
                  hyprctl notify -1 1000 "rgb(${borderColor})" "Notifications Shown"
              else
                  makoctl mode -a do-not-disturb
                  hyprctl notify -1 1000 "rgb(${borderColor})" "Notifications Hidden"
              fi
            '';
          }
        )
      );
    };
}
