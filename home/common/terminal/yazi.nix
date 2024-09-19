{
  lib,
  config,
  ...
}: {
  options.nix-files.terminal.yazi.enable = lib.mkEnableOption "Yazi config";

  config = lib.mkIf config.nix-files.terminal.yazi.enable {
    programs.yazi.enable = true;

    home.persistence."/persist${config.home.homeDirectory}".directories = [
      ".local/state/yazi"
    ];
  };
}
