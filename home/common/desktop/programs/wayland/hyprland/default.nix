{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  home.packages = with pkgs; [
    # inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    # package = inputs.hyprland.packages."${pkgs.system}".hyprland;

    systemd = {
      enable = true;
      variables = ["--all"]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
    };

    xwayland.enable = true;
  };
}
