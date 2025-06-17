{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.nix-files.parts.system.persistence.enable = lib.mkEnableOption "Persistence config";

  config = lib.mkIf config.nix-files.parts.system.persistence.enable {
    home.persistence."/persist" = {
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
    };
  };
}
