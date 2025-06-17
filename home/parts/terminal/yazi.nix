{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.terminal.yazi.enable = lib.mkEnableOption "Yazi config";

  config = lib.mkIf config.nix-files.parts.terminal.yazi.enable {
    programs.yazi.enable = true;

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".local/state/yazi"
      ];
    };
  };
}
