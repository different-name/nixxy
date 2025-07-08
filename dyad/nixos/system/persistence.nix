{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (lib) types;
  cfg = config.dyad.system.persistence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.dyad.system.persistence = {
    enable = lib.mkEnableOption "persistence config";

    # we accept a list of anything so that impermanence will handle the typing instead
    # this is less maintenance in the event impermemance changes typing
    dirs = lib.mkOption {
      type = types.listOf types.anything;
      default = [ ];
      description = "directories to pass to persistence config";
    };

    files = lib.mkOption {
      type = types.listOf types.anything;
      default = [ ];
      description = "files to pass to persistence config";
    };

    home = {
      dirs = lib.mkOption {
        type = types.listOf types.anything;
        default = [ ];
        description = "directories to pass to home-manager persistence config";
      };

      files = lib.mkOption {
        type = types.listOf types.anything;
        default = [ ];
        description = "files to pass to home-manager persistence config";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist/system" = {
      inherit (cfg) files;
      directories = cfg.dirs;
      hideMounts = true;
    };

    home-manager.users = self.lib.forAllUsers config {
      home.persistence-wrapper = {
        inherit (cfg.home) dirs files;
      };
    };

    # required for impermanence to work
    fileSystems."/persist".neededForBoot = true;
  };
}
