{
  # use keyd -m to find devices & key codes
  services.keyd = {
    enable = true;
    keyboards = {
      ikki68aurora = {
        ids = ["1ea7:7777"];
        settings.main = {
          insert = "print";
        };
      };
    };
  };
}
