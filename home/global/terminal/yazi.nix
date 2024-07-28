{osConfig, ...}: {
  programs.yazi = {
    enable = true;
  };

  home.persistence."/persist/home/${osConfig.nix-files.user}".directories = [
    ".local/state/yazi"
  ];
}
