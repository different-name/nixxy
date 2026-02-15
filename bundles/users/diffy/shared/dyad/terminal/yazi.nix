{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "yazi" ] {
  home-manager =
    { pkgs, ... }:
    {
      programs.yazi.enable = true;

      # wrapper for yazi https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
      programs.fish.functions = {
        yazi = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          ${lib.getExe pkgs.yazi} $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      home.perpetual.default.dirs = [
        "$stateHome/yazi"
      ];
    };
}
