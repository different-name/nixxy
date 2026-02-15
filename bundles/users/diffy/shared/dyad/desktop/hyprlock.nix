{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "hyprlock" ] {
  home-manager.programs.hyprlock = {
    enable = true;

    settings = {
      animations.enabled = false;
    };
  };
}
