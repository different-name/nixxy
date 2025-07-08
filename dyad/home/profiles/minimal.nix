{ lib, config, ... }:
{
  options.dyad.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.dyad.profiles.minimal.enable {
    dyad.system.persistence = {
      enable = true;
      dirs = [
        # keep-sorted start
        ".local/share/Trash"
        ".terminfo"
        "nix-files"
        # keep-sorted end
      ];
    };
  };
}
