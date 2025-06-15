{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.meta.nvidia.enable = lib.mkEnableOption "Nvidia config";

  config = lib.mkIf config.nix-files.graphical.meta.nvidia.enable {
    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/nvidia"
      ];
    };
  };
}
