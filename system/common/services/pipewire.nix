{
  lib,
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.wireplumber-connectPorts
  ];

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
  };
}
