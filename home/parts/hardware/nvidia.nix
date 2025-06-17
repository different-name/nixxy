{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.hardware.nvidia.enable = lib.mkEnableOption "Nvidia config";

  config = lib.mkIf config.nix-files.parts.hardware.nvidia.enable {
    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".cache/nvidia"
      ];
    };
  };
}
