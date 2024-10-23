{
  lib,
  config,
  ...
}: {
  options.nix-files.programs.hyprland.enable = lib.mkEnableOption "Hyprland config";

  config = lib.mkIf config.nix-files.programs.hyprland.enable {
    programs.hyprland = {
      enable = true;
      # package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      # portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    };

    # hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # always start Hyprland on tty1 after login
    environment.loginShellInit = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec Hyprland
      fi
    '';
  };
}
