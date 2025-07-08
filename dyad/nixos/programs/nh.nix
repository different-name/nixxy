{
  lib,
  config,
  inputs',
  ...
}:
{
  options.dyad.programs.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.dyad.programs.nh.enable {
    # nh is a nix cli helper, useful for rebuilding & cleaning
    programs.nh = {
      enable = true;

      package = inputs'.nh.packages.nh;

      # weekly garbage collection
      clean = {
        enable = true;
        # keep configs from last 30 days
        extraArgs = "--keep-since 30d";
      };
    };

    environment.persistence-wrapper.home.dirs = [
      ".cache/nix-output-monitor"
    ];
  };
}
