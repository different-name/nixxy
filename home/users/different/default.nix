{config, ...}: {
  imports = [
    ../.
  ];

  home = {
    username = "different";
    homeDirectory = "/home/${config.home.username}";
  };
}
