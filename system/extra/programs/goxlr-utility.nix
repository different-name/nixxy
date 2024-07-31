{pkgs, ...}: {
  services.goxlr-utility = {
    enable = true;
    # workaround for https://github.com/NixOS/nixpkgs/issues/331319
    package = pkgs.goxlr-utility.overrideAttrs (oldAttrs: {
      postInstall = builtins.replaceStrings ["--replace goxlr-launcher goxlr-daemon"] [""] oldAttrs.postInstall;
    });
  };
}
