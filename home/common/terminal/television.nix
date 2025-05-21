{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.terminal.television.enable = lib.mkEnableOption "Television config";

  config = lib.mkIf config.nix-files.terminal.television.enable {
    programs.television = {
      enable = true;
      package = pkgs.symlinkJoin {
        name = "television";
        paths = [pkgs.television];
        buildInputs = [pkgs.makeWrapper];
        postBuild = "wrapProgram $out/bin/tv --add-flags '--exact'";
      };

      enableFishIntegration = true;

      # TODO https://github.com/alexpasmantier/television/issues/520
      # settings = {
      #   default_channel = "nixpkgs";
      # };

      channels = {
        nix = {
          cable_channel = let
            nix-search-tv = pkgs.nix-search-tv + /bin/tv;
          in [
            {
              name = "nixpkgs";
              source_command = "${nix-search-tv} print";
              preview_command = "${nix-search-tv} preview {}";
            }
          ];
        };
      };
    };
  };
}
