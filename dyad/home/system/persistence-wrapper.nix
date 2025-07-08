{
  lib,
  config,
  self,
  ...
}:
{
  imports = [
    self.homeModules.impermanenceWrapper
  ];

  options.dyad.system.persistence-wrapper.enable = lib.mkEnableOption "persistence-wrapper config";

  config = lib.mkIf config.dyad.system.persistence-wrapper.enable {
    home.persistence-wrapper = {
      enable = true;
      persistentStorage = "/persist";

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
