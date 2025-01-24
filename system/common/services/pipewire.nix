{
  lib,
  config,
  ...
}: {
  options.nix-files.services.pipewire.enable = lib.mkEnableOption "Pipewire config";

  config = lib.mkIf config.nix-files.services.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    services.pulseaudio.enable = lib.mkForce false;

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/etc/pipewire"
      ];
    };
  };
}
