{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.terminal.television.enable = lib.mkEnableOption "television config";

  config = lib.mkIf config.dyad.terminal.television.enable {
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

    home.persistence-wrapper.dirs = [
      # keep-sorted start
      ".cache/nix-search-tv"
      ".local/share/television"
      # keep-sorted end
    ];
  };
}
