{
  lib,
  config,
  osConfig,
  self',
  pkgs,
  ...
}:
let
  flakeRepl = ''
    let
      flake = builtins.getFlake "${config.programs.nh.flake}";
      inherit (flake.nixosConfigurations."${osConfig.networking.hostName}") lib pkgs;
    in
    {
      inherit flake lib pkgs;
      f = flake;
    }
  '';
in
{
  options.dyad.terminal.dyad.enable = lib.mkEnableOption "dyad config";

  config = lib.mkIf config.dyad.terminal.dyad.enable {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "dyad";

        runtimeInputs = with pkgs; [
          # keep-sorted start
          just
          nvfetcher
          osConfig.programs.nh.package
          # keep-sorted end
        ];

        text = ''
          cd ${config.programs.nh.flake}
          exec just "$@"
        '';
      })

      (pkgs.writeShellScriptBin "dyad-fmt" ''
        exec ${lib.getExe self'.formatter} "$@"
      '')

      (pkgs.writeShellScriptBin "dyad-flake-repl" ''
        exec ${lib.getExe pkgs.nix} repl --expr \
          ${lib.escapeShellArg flakeRepl} "$@"
      '')
    ];
  };
}
