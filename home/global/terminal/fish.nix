{
  programs.fish = {
    enable = true;
    catppuccin.enable = false;

    shellInit = ''
      set -U fish_color_cwd red
      set -U fish_color_user red
      fastfetch
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
