{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.nix-files.parts.system.persistence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options.nix-files.parts.system.persistence = {
    enable = lib.mkEnableOption "persistence config";

    # we accept a list of anything so that impermanence will handle the typing instead
    # this is less maintenance in the event impermemance changes typing
    directories = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "directories to pass to persistence config";
    };

    files = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      description = "files to pass to persistence config";
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence."/persist" = {
      inherit (cfg) directories files;
    };
  };
}
