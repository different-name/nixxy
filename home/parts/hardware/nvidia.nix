{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.hardware.nvidia.enable = lib.mkEnableOption "Nvidia config";

  config = lib.mkIf config.nix-files.parts.hardware.nvidia.enable {
    nix-files.parts.system.persistence = {
      directories = [
        ".cache/nvidia"
      ];
    };
  };
}
