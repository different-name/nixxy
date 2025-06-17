{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nix-files.parts.terminal.television.enable = lib.mkEnableOption "Television config";

  config = lib.mkIf config.nix-files.parts.terminal.television.enable {
    programs.television = {
      enable = true;

      channels = {
        nix = {
          cable_channel =
            let
              nix-search-tv = lib.getExe pkgs.nix-search-tv;
            in
            [
              {
                name = "nixpkgs";
                source_command = "${nix-search-tv} print";
                preview_command = "${nix-search-tv} preview {}";
              }
            ];
        };
      };

      enableBashIntegration = false;
      enableFishIntegration = false;
      enableZshIntegration = false;
    };

    home.shellAliases = {
      nixpkgs = "tv nixpkgs --exact";
    };

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".local/share/television"
        ".cache/nix-search-tv"
      ];
    };
  };
}
