{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  home.persistence."/persist/home/different".directories = [
    ".config/obs-studio"
  ];
}
