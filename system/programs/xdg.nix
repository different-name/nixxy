{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    mime = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/unityhub" = "unityhub.desktop";
      };
    };
  };
}
