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
        ".ssh"
        ".terminfo"
        ".local/share/Trash"
        ".cache/fontconfig"
        ".cache/nix"
        ".cache/nix-output-monitor"
        ".cache/gstreamer" # not sure what this is from
      ];

      files = [
        ".local/share/nix/repl-history"
      ];

      allowOther = true;
    };
  };
}
