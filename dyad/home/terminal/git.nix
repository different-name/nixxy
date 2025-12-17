{ lib, config, ... }:
{
  options.dyad.terminal.git.enable = lib.mkEnableOption "git config";

  config = lib.mkIf config.dyad.terminal.git.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings.user = {
        name = "diffy";
        email = "hello@different-name.dev";
      };
    };
  };
}
