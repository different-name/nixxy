{ lib, config, ... }:
{
  options.dyad.desktop.uwsm.enable = lib.mkEnableOption "uwsm config";

  config = lib.mkIf config.dyad.desktop.uwsm.enable {
    programs.uwsm.enable = true;

    environment = {
      # auto launch hyprland on tty1
      loginShellInit = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && uwsm check may-start; then
          exec uwsm start select
        fi
      '';

      # hint electron apps to use wayland
      sessionVariables.NIXOS_OZONE_WL = 1;
    };
  };
}
