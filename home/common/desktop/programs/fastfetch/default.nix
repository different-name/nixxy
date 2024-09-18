{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "kitty-direct";
        source = ./fastfetch.png;
        width = 18;
        height = 8;
        padding = {
          left = 0;
          right = 2;
        };
      };

      display = {
        separator = ": ";
        color = {
          title = "red";
          separator = "dim_white";
          keys = "red";
        };
      };

      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        {
          key = "Compositor";
          type = "wm";
        }
        "terminal"
        "bios"
        "kernel"
      ];
    };
  };
}
