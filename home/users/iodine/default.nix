{config, ...}: {
  imports = [
    ../.
  ];

  home = {
    username = "iodine";
    homeDirectory = "/home/${config.home.username}";
  };
}
