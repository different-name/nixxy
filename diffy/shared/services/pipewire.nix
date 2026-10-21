{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "pipewire" ] {
  nixos = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

  home-manager.keep.persist.xdg.state.dirs."wireplumber" = { }; # audio settings
}
