{
  pkgs,
  config,
  ...
}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  home.persistence."/persist${config.home.homeDirectory}".directories = [
    ".config/obs-studio"
  ];
}
