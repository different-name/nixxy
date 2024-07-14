{
  services.keyd = {
    enable = true;
    keyboards = {
      ikki68aurora = {
        ids = ["*"]; # TODO
        settings.main = {
          insert = "print";
        };
      };
    };
  };
}
