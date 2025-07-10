{
  lib,
  config,
  ...
}:
{
  options.dyad.terminal.tmux.enable = lib.mkEnableOption "tmux config";

  config = lib.mkIf config.dyad.terminal.tmux.enable {
    programs.tmux = {
      enable = true;
      # wip!
    };
  };
}
