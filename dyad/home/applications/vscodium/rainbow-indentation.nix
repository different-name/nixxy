{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.vscodium.enable {
    programs.vscode.profiles.default.userSettings = {
      # keep-sorted start block=yes newline_separated=yes
      "editor.guides.bracketPairs" = true;

      "editor.guides.bracketPairsHorizontal" = false;

      "editor.guides.highlightActiveBracketPair" = true;

      "workbench.colorCustomizations" = {
        # keep-sorted start
        "editorBracketPairGuide.activeBackground1" = "#f38ba8";
        "editorBracketPairGuide.activeBackground2" = "#fab387";
        "editorBracketPairGuide.activeBackground3" = "#f9e2af";
        "editorBracketPairGuide.activeBackground4" = "#a6e3a1";
        "editorBracketPairGuide.activeBackground5" = "#74c7ec";
        "editorBracketPairGuide.activeBackground6" = "#cba6f7";
        "editorBracketPairGuide.background1" = "#f38ba899";
        "editorBracketPairGuide.background2" = "#fab38799";
        "editorBracketPairGuide.background3" = "#f9e2af99";
        "editorBracketPairGuide.background4" = "#a6e3a199";
        "editorBracketPairGuide.background5" = "#74c7ec99";
        "editorBracketPairGuide.background6" = "#cba6f799";
        # keep-sorted end
      };
      # keep-sorted end
    };
  };
}
