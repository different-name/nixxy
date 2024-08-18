{config, ...}: {
  imports = [
    ../../common/global
    ../../common/desktop
  ];

  home = {
    username = "different";
    homeDirectory = "/home/${config.home.username}";
  };
}
