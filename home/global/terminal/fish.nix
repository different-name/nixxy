{
  programs.fish = {
    enable = true;
    catppuccin.enable = false;
  };

  programs.fish.shellInit = ''
    set -U fish_color_cwd red
    set -U fish_color_user red
    fastfetch
  '';
}
