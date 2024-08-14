{
  programs.yazi = {
    enable = true;
  };

  home.persistence."/persist/home/different".directories = [
    ".local/state/yazi"
  ];
}
