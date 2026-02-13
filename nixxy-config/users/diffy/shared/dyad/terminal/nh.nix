{ lib, config, ... }:
{
  options.dyad.programs.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.dyad.programs.nh.enable {
    # nh is a nix cli helper, useful for rebuilding & cleaning
    nixos.programs.nh = {
      enable = true;

      # weekly garbage collection
      clean = {
        enable = true;
        # keep configs from last 30 days
        extraArgs = "--keep-since 30d";
      };
    };

    hm =
      { config, osConfig, ... }:
      {
        programs.nh = {
          enable = true;
          package = lib.mkDefault osConfig.programs.nh.package;
          flake = "${config.home.homeDirectory}/nixxy";
        };

        home.perpetual.default.dirs = [
          "$cacheHome/nix-output-monitor"
        ];
      };
  };
}
