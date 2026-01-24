{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (inputs.nixpkgs-librewolf.legacyPackages.${system}) librewolf;
in
{
  options.dyad.applications.librewolf.enable = lib.mkEnableOption "librewolf config";

  config = lib.mkIf config.dyad.applications.librewolf.enable {
    programs.librewolf = {
      enable = true;

      # TODO remove after fix for https://github.com/nixos/nixpkgs/issues/482250 is merged
      package = librewolf;

      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "librewolf.desktop";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/librewolf"
      ".librewolf"
    ];
  };
}
