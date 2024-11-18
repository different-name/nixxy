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

    graphical.meta.nvidia.enable = true;

    services.goxlr-utility.enable = true;
  };

  ### host specific

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  ### required config

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
