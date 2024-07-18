{pkgs, osConfig, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  home.persistence."/persist/home/${osConfig.nix-files.user}".directories = [
    ".config/obs-studio"
  ];
}