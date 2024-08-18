{config, ...}: {
  imports = [
    ../../common/global
  ];

  home = {
    username = "iodine";
    homeDirectory = "/home/${config.home.username}";
  };
}
