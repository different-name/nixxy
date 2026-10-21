{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "nh" ] {
  nixos.programs.nh = {
    enable = true;

    # weekly garbage collection
    clean = {
      enable = true;
      extraArgs = "--keep-since 30d --keep 5";
    };
  };

  home-manager = { config, osConfig, ... }: {
    programs.nh = {
      enable = true;
      package = lib.mkDefault osConfig.programs.nh.package;
      flake = config.dyad.flake;
    };

    keep.safe.cacheDirs = [ "nix-output-monitor" ];
  };
}
