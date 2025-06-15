{
  lib,
  config,
  ...
}: {
  options.nix-files.terminal.yazi.enable = lib.mkEnableOption "Yazi config";

  config = lib.mkIf config.nix-files.terminal.yazi.enable {
    programs.yazi.enable = true;

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".local/state/yazi"
      ];
    };
  };
}
