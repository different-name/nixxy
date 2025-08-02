{
  lib,
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    # keep-sorted start block=yes
    inputs.impermanence.homeManagerModules.impermanence
    self.homeModules.perpetual # impermanence option bindings
    {
      # required since other configs try to use 'default'
      home.persistence.default.persistentStoragePath = lib.mkDefault "/persist";
    }
    # keep-sorted end
  ];

  options.dyad.system.perpetual.enable = lib.mkEnableOption "perpetual config";

  config = lib.mkIf config.dyad.system.perpetual.enable {
    home.persistence.default = {
      persistentStoragePath = "/persist";
      hideMounts = true;
      enableWarnings = true;
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$dataHome/Trash"
      ".terminfo"
      "nix-files"
      # keep-sorted end
    ];
  };
}
