{
  lib,
  config,
  ...
}: {
  options.nix-files.nix.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.nix-files.nix.nh.enable {
    # nh is a nix cli helper, useful for rebuilding & cleaning
    programs.nh = {
      enable = true;

      # weekly garbage collection
      clean = {
        enable = true;
        # keep configs from last 30 days
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
