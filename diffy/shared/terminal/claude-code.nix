{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "claude-code" ] {
  home-manager =
    { config, ... }:
    {
      home.perpetual.default.packages.claude-code = {
        dirs = [ ".claude" ];
        files = [ ".claude.json" ];
      };

      home.file.".claude/CLAUDE.md".text = ''
        # global preferences
        ${lib.optionalString config.programs.nushell.enable ''
          - i use nushell as my shell. provide shell snippets in nushell syntax, not bash/posix.
        ''}
      '';
    };
}
