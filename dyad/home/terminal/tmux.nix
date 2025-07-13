{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.terminal.tmux.enable = lib.mkEnableOption "tmux config";

  config = lib.mkIf config.dyad.terminal.tmux.enable {
    programs.tmux = {
      enable = true;

      plugins = with pkgs.tmuxPlugins; [
        sensible
      ];

      # keep-sorted start
      baseIndex = 1;
      keyMode = "vi";
      mouse = true;
      shell = lib.getExe config.programs.fish.package;
      shortcut = "Space";
      # keep-sorted end

      extraConfig = ''
        set -g renumber-windows on
      '';
    };
  };
}
