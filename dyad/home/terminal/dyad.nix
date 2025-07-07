{
  lib,
  config,
  osConfig,
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
          just
          nvfetcher
          osConfig.programs.nh.package
        ];

        text = ''
          cd ${config.dyad.flake}
          exec just "$@"
        '';
      })
    ];
  };
}
