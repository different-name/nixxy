{
  # use keyd -m to find devices & key codes
  services.keyd = {
    enable = true;
    keyboards = {
      all = {
        ids = ["*"];
        settings.main = {
          # will update to something more useful when needed
          capslock = "leftshift";
        };
      };
      ikki68aurora = {
        ids = ["1ea7:7777"];
        settings.main = {
          insert = "print";
        };
      };
    };
  };
}
