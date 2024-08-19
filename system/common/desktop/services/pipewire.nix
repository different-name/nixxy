{lib, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire-pulse = {
      # https://askubuntu.com/a/1510696
      # Disable WebRTC in chromium from writing to input volume
      # Weird feature, allows websites with microphone access to set your microphone volume
      "block-source-volume" = {
        "pulse.rules" = [
          {
            matches = [
              {
                #"client.name" = "~(Chromium|Brave|electron)( input)?";
                "application.process.binary" = "~.*";
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

  environment.persistence."/persist/system".directories = [
    "/etc/pipewire"
  ];
}
