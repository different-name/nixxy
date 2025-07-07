{ lib, config, ... }:
{
  options.dyad.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.dyad.profiles.minimal.enable {
    dyad = {
      system = {
        persistence = {
          enable = true;

          directories = [
            "nix-files"
            ".terminfo"
            ".local/share/Trash"
          ];
        };
      };
    };
  };
}
