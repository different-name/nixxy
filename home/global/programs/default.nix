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
    ./zathura.nix
    ./xdg.nix
  ];

  home.packages =
    (with pkgs; [
      # util
      brave
      pavucontrol
      qalculate-gtk
      gimp-with-plugins

      # games
      vesktop
      unityhub
      # wlx-overlay-s
      # (prismlauncher.override {
      #   jdks = [
      #     zulu17
      #     zulu21
      #   ];
      # })

      # work
      slack
      libreoffice-qt6-fresh
    ]);
}
