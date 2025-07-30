{ lib, config, ... }:
{
  options.dyad.terminal.git.enable = lib.mkEnableOption "git config";

  config = lib.mkIf config.dyad.terminal.git.enable {
    programs.git = {
      enable = true;
      userName = "diffy";
      userEmail = "hello@different-name.dev";
      lfs.enable = true;
    };
  };
}
