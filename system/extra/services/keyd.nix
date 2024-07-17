{
  services.keyd = {
    enable = true;
    keyboards = {
      ikki68aurora = {
        ids = ["1ea7:7777"]; # lsusb
        settings.main = {
          insert = "print";
        };
      };
    };
  };
}
