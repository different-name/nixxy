{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.global.enable = lib.mkEnableOption "Global profile";

  config = lib.mkIf config.nix-files.profiles.global.enable {
    programs.fzf.enable = true;
    programs.fd.enable = true;

    nix-files = {
      catppuccin.enable = true;

      terminal = {
        fastfetch.enable = true;
        btop.enable = true;
        fish.enable = true;
        git.enable = true;
        yazi.enable = true;
      };
    };
  };
}
