{config, ...}: {
  imports = [
    ../../global
    ../../desktop
  ];

  home = {
    username = "different";
    homeDirectory = "/home/${config.home.username}";
  };
}
