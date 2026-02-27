{ bundleLib, lib, ... }:
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

    services.pulseaudio.enable = lib.mkForce false;
  };

  home-manager.home.perpetual.default.dirs = [
    "$stateHome/wireplumber" # audio settings
  ];
}
