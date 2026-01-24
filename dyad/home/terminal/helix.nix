{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.terminal.helix.enable = lib.mkEnableOption "helix config";

  config = lib.mkIf config.dyad.terminal.helix.enable {
    programs.helix = {
      enable = true;

      extraPackages = with pkgs; [
        # keep-sorted start
        bash-language-server
        gopls # go
        lua-language-server
        marksman # markdown
        ruff # python
        taplo # toml
        typescript-language-server
        vscode-css-languageserver
        vscode-json-languageserver
        # keep-sorted end
      ];

      languages = {
        language-server.nixd = {
          command = lib.getExe pkgs.nixd;
          options.nixos.expr = "(builtins.getFlake \"${config.programs.nh.flake}\").nixosConfigurations.<name>.options";
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt;
          }
        ];
      };
    };
  };
}
