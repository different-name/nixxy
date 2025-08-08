{
  lib,
  config,
  osConfig,
  self',
  pkgs,
  ...
}:
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
    ];
  };
}
