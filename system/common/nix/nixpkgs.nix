{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nur.modules.nixos.default
  ];

  options.nix-files.nix.nixpkgs.enable = lib.mkEnableOption "Nixpkgs config";

  config = lib.mkIf config.nix-files.nix.nixpkgs.enable {
    nixpkgs.config.allowUnfree = true;

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}
