{
  osConfig,
  pkgs,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    # TODO remove this when nixpkgs is updated
    package = pkgs.fastfetch.overrideAttrs (finalAttrs: {
      version = "2.20.0";
      src = pkgs.fetchFromGitHub {
        owner = "fastfetch-cli";
        repo = "fastfetch";
        rev = "2.20.0";
        hash = "sha256-8N2BG9eTZpAvnc1wiG6p7GJSCPfZ+NTbz8kLGPRg5HU=";
      };
    });
    settings = {
      logo = {
        type = "kitty-direct";
        source = ../../../assets/fastfetch.png;
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
        "packages"
        {
          type = "memory";
          percent = {
            green = 0;
            yellow = 0;
          };
        }
      ];
    };
  };
}
