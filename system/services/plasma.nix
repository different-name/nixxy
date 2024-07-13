{pkgs, ...}: {
  services.xserver = {
    enable = true;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        autoLogin.relogin = true;
      };

      autoLogin = {
        enable = true;
        user = "different";
      };

      defaultSession = "plasma";
    };

    desktopManager.plasma6.enable = true;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration # does not seem to have brave integration on nixos
    konsole # kitty
    elisa # mpv
    okular # TODO libreoffice or similar
    kate # vscodium
    khelpcenter
    spectacle # TODO lighter weight screenshot util
    krdp
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5"; # TODO per host scaling
  };
}
