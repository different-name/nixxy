{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "television" ] {
  home-manager = { pkgs, ... }: {
    programs.television = {
      enable = true;

      channels = {
        nix = {
          cable_channel =
            let
              nix-search-tv = lib.getExe pkgs.nix-search-tv;
            in
            lib.singleton {
              name = "nixpkgs";
              source_command = "${nix-search-tv} print";
              preview_command = "${nix-search-tv} preview {}";
            };
        };
      };

      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };

    home.shellAliases = {
      nixpkgs = "tv nixpkgs --exact";
    };

    keep.safe = {
      cacheDirs = [ "nix-search-tv" ];
      dataDirs = [ "television" ];
    };
  };
}
