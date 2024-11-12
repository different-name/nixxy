{
  lib,
  config,
  ...
}: {
  options.nix-files.programs.uwsm.enable = lib.mkEnableOption "UWSM config";

  config = lib.mkIf config.nix-files.programs.uwsm.enable {
    programs.uwsm = {
      enable = true;

      waylandCompositors.hyprland = lib.mkIf config.nix-files.programs.hyprland.enable {
        binPath = "/run/current-system/sw/bin/Hyprland";
        comment = "Hyprland session managed by uwsm";
        prettyName = "Hyprland";
      };
    };

    # compositor selection menu on tty1
    environment.loginShellInit = ''
      if uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
