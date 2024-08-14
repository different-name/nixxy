{config, ...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      set -U fish_color_cwd red
      set -U fish_color_user red
      ${
        if config.programs.fastfetch.enable
        then "fastfetch"
        else ""
      }
    '';

    functions = {
      yy = ''
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
    };
  };
}
