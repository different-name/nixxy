{
  pkgs,
  self,
  ...
}: let
  customPkgs = self.packages.${pkgs.system};
in {
  imports = [
    ./wayland
    ./catppuccin.nix
    ./gtk.nix
    ./imv.nix
    ./mpv.nix
    ./obs.nix
    ./qt.nix
    ./vscodium.nix
    ./xdg.nix
  ];

  home.packages =
    (with pkgs; [
      # util
      brave
      pavucontrol
      gnome-calculator
      gimp-with-plugins

      # games
      vesktop
      unityhub
      vrc-get
      wlx-overlay-s
      # (prismlauncher.override {
      #   jdks = [
      #     zulu17
      #     zulu21
      #   ];
      # })

      # work
      slack
      libreoffice-qt6-fresh
    ])
    ++ (with customPkgs; [
      ente-photos-desktop
    ]);
}
