{ lib, config, ... }:
{
  options.nix-files.parts.terminal.yazi.enable = lib.mkEnableOption "yazi config";

  config = lib.mkIf config.nix-files.parts.terminal.yazi.enable {
    programs.yazi.enable = true;

    nix-files.parts.system.persistence = {
      directories = [
        ".local/state/yazi"
      ];
    };
  };
}
