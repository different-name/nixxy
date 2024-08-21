{config, ...}: {
  programs.obs-studio.enable = true;

  home.persistence."/persist${config.home.homeDirectory}".directories = [
    ".config/obs-studio"
  ];
}
