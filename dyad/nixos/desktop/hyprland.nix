{
  lib,
  config,
  inputs,
  inputs',
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  hyprlandPkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in
{
  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    # TODO remove when withUWSM option sets env vars correctly
    programs.uwsm.waylandCompositors.hyprland.binPath = lib.mkForce (
      pkgs.writeTextFile {
        name = "start-hyprland-wrapper";
        executable = true;
        text = ''
          #!${pkgs.runtimeShell}
          exec ${lib.getExe' config.programs.hyprland.package "start-hyprland"}
        '';
        checkPhase = ''
          ${pkgs.stdenv.shellDryRun} "$target"
        '';
        destination = "/Hyprland";
      }
      + /Hyprland
    );

    hardware.graphics.package = hyprlandPkgs.mesa;
  };
}
