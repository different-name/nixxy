{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
  };

  # hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # always start Hyprland on tty1 after login
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      exec Hyprland
    fi
  '';
}
