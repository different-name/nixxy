{
  lib,
  config,
  self,
  ...
}:
{
  imports = [
    self.nixosModules.wireplumberScripts
  ];

  options.dyad.services.pipewire.enable = lib.mkEnableOption "pipewire config";

  config = lib.mkIf config.dyad.services.pipewire.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    services.pulseaudio.enable = lib.mkForce false;

    dyad.system.persistence = {
      home.dirs = [
        # audio settings
        ".local/state/wireplumber"
      ];
    };
  };
}
