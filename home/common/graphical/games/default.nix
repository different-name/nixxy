{pkgs, ...}: {
  imports = [
    ./steam.nix
  ];

  home.packages = with pkgs; [
    vesktop
    lutris
    heroic
    osu-lazer-bin
    (prismlauncher.override {
      jdks = [
        zulu8
        zulu17
        zulu21
      ];
    })
  ];
}
