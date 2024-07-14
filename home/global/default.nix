{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./programs
    ./services
    ./terminal
    ./persistence.nix

    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  nixpkgs.config.allowUnfree = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    username = "different";
    homeDirectory = "/home/different";

    packages = with pkgs; [
      # programs
      vesktop
      brave
      pavucontrol
      slack
      gnome.gnome-calculator
      #networkmanagerapplet # TODO do i need this?
      gimp-with-plugins
      unityhub
      libreoffice-qt6-fresh
      # (prismlauncher.override {
      #   jdks = [
      #     zulu17
      #     zulu21
      #   ];
      # })

      # terminal
      imagemagick
      ani-cli
      trashy
      ncdu

      # services
      libnotify
    ];
  };
}
