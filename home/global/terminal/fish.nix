{
  programs.fish = {
    enable = true;
    catppuccin.enable = false;
  };

  # xdg.configFile."fish/themes/Catppuccin Mocha Edit.theme".text = ''
  #   # name: 'Catppuccin Mocha Edit'
  #   # url: 'https://github.com/catppuccin/fish'
  #   # preferred_background: 1e1e2e

  #   fish_color_normal cdd6f4
  #   fish_color_command f38ba8
  #   fish_color_param f2cdcd
  #   fish_color_keyword f38ba8
  #   fish_color_quote a6e3a1
  #   fish_color_redirection f5c2e7
  #   fish_color_end fab387
  #   fish_color_comment 7f849c
  #   fish_color_error f38ba8
  #   fish_color_gray 6c7086
  #   fish_color_selection --background=313244
  #   fish_color_search_match --background=313244
  #   fish_color_option a6e3a1
  #   fish_color_operator f5c2e7
  #   fish_color_escape eba0ac
  #   fish_color_autosuggestion 6c7086
  #   fish_color_cancel f38ba8
  #   fish_color_cwd f2cdcd
  #   fish_color_user f38ba8
  #   fish_color_host f38ba8
  #   fish_color_host_remote a6e3a1
  #   fish_color_status f38ba8
  #   fish_pager_color_progress 6c7086
  #   fish_pager_color_prefix f5c2e7
  #   fish_pager_color_completion cdd6f4
  #   fish_pager_color_description 6c7086
  # '';

  # programs.fish.shellInit = ''
  #   fish_config theme choose "Catppuccin Mocha Edit"
  # '';
}
