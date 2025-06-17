{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.wireplumber-connectPorts
  ];

  options.nix-files.parts.services.pipewire.enable = lib.mkEnableOption "Pipewire config";

  config = lib.mkIf config.nix-files.parts.services.pipewire.enable {
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
