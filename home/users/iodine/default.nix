{config, ...}: {
  imports = [
    ../../global
  ];

  home = {
    username = "iodine";
    homeDirectory = "/home/${config.home.username}";
  };
}
