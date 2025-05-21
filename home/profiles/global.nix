{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.global.enable = lib.mkEnableOption "Global profile";

  config = lib.mkIf config.nix-files.profiles.global.enable {
    # programs
    programs.fd.enable = true;

    # modules
    nix-files = {
      catppuccin.enable = true;
      core.enable = true;
      persistence.enable = true;

      terminal = {
        enable = true; # terminal packages
        fastfetch.enable = true;
        btop.enable = true;
        fish.enable = true;
        git.enable = true;
        television.enable = true;
        yazi.enable = true;
      };
    };
  };
}
