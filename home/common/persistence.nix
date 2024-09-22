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
    home.persistence = {
      "/persist${config.home.homeDirectory}" = {
        allowOther = true;

        directories = [
          "nix-files"
          ".ssh"
          ".terminfo"
          ".local/share/kitty-ssh-kitten"
          ".local/share/Trash"
        ];

        files = [
          ".local/share/nix/repl-history"
        ];
      };

      "/persist${config.home.homeDirectory}-cache" = {
        allowOther = true;

        directories = [
          ".cache"
        ];
      };
    };
  };
}
