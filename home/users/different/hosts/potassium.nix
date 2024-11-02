{
  imports = [
    ../.
  ];

  ### modules

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };
  };

  ### required config

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
