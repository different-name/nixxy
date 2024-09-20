{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.nix-files.persistence.enable = lib.mkEnableOption "Persistence config";

  config = lib.mkIf config.nix-files.persistence.enable {
    home.persistence."/persist${config.home.homeDirectory}" = {
      directories = [
        "nix-files"
        ".cache"
        ".ssh"
        ".terminfo"
        ".local/share/Trash"
      ];

      files = [
        ".local/share/nix/repl-history"
      ];

      allowOther = true;
    };
  };
}
