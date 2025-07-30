{ lib, config, ... }:
{
  options.dyad.desktop.uwsm.enable = lib.mkEnableOption "uwsm config";

  config = lib.mkIf config.dyad.desktop.uwsm.enable {
    programs.uwsm.enable = true;

    # auto launch hyprland on tty1
    environment.loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
