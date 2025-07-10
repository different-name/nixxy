{ lib, config, ... }:
{
  options.dyad.terminal.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.terminal.fish.enable {
    programs.fish.enable = true;

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/fish"
      "$dataHome/fish"
      # keep-sorted end
    ];
  };
}
