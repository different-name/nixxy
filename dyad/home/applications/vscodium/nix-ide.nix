{
  lib,
  config,
  inputs',
  pkgs,
  ...
}:
{
  config = lib.mkIf config.dyad.applications.vscodium.enable {
    programs.vscode.profiles.default = {
      extensions = with inputs'.nix-vscode-extensions.extensions.vscode-marketplace; [
        jnoortheen.nix-ide
      ];

      userSettings = {
        # keep-sorted start block=yes newline_separated=yes
        "nix.enableLanguageServer" = true;

        "nix.hiddenLanguageServerErrors" = [
          # keep-sorted start
          "textDocument/codeAction"
          "textDocument/completion"
          "textDocument/definition"
          "textDocument/documentHighlight"
          "textDocument/documentLink"
          "textDocument/documentSymbol"
          "textDocument/hover"
          "textDocument/inlayHint"
          # keep-sorted end
        ];

        "nix.serverPath" = "${lib.getExe pkgs.nixd}";

        "nix.serverSettings.nixd.formatting.command" = [
          "${lib.getExe pkgs.nixfmt}"
        ];

        "nix.serverSettings.nixd.options.nixos.expr" =
          "(builtins.getFlake \"${config.programs.nh.flake}\").nixosConfigurations.<name>.options";
        # keep-sorted end
      };
    };
  };
}
