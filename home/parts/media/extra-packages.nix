{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.parts.media.extra-packages.enable = lib.mkEnableOption "extra media packages";

  config = lib.mkIf config.nix-files.parts.media.extra-packages.enable {
    home.packages = with pkgs; [
      ani-cli
      video-trimmer
    ];
  };
}
