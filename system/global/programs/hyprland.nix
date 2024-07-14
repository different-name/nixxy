{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  # hint electron apps to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  };

  # always start Hyprland on tty1 after login
  environment.loginShellInit = ''
    if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      exec Hyprland
    fi
  '';
}
