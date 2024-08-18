{config, ...}: {
  programs.yazi = {
    enable = true;
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [
    ".local/state/yazi"
  ];
}
