{lib, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      # https://askubuntu.com/a/1510696
      # Disable WebRTC in chromium from writing to input volume
      # Weird feature, allows websites with microphone access to set your microphone volume
      extraConfig = {
        access.rules = [
          {
            matches = [
              {
                "client.name" = "~(Chromium|Brave|electron)( input)?";
              }
            ];
            actions = {
              quirks = ["block-source-volume"];
            };
          }
        ];
      };
    };
  };

  hardware.pulseaudio.enable = lib.mkForce false;
}
