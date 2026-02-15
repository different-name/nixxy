{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "nh" ] {
  nixos.programs.nh = {
    enable = true;

    # weekly garbage collection
    clean = {
      enable = true;
      # keep configs from last 30 days
      extraArgs = "--keep-since 30d";
    };
  };

  home-manager =
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
}
