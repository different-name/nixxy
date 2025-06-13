{
  lib,
  config,
  osConfig,
  ...
}: {
  options.nix-files.terminal.btop.enable = lib.mkEnableOption "Btop config";

  config = lib.mkIf config.nix-files.terminal.btop.enable {
    programs.btop = {
      enable = true;

      settings = {
        proc_gradient = false;
        proc_mem_bytes = false;
        show_swap = false;

        # all system level persisted directories need to be exlcuded through the disk filter
        # otherwise they will show up as a physical disk in btop
        disks_filter = let
          excludeDirectories =
            # retrieve all system level persited directories
            (lib.flatten (
              map
              # map each persistence config to a list of persisted directories
              (persistenceConfig: map (dir: dir.dirPath) persistenceConfig.directories)
              # data from system's persistence configs
              (builtins.attrValues osConfig.environment.persistence)
            ))
            # manual additions
            ++ [
              "/boot"
              "${config.home.homeDirectory}/.steam"
            ];
        in
          lib.mkIf config.nix-files.persistence.enable "exclude=${lib.concatStringsSep " " excludeDirectories}";
      };
    };
  };
}
