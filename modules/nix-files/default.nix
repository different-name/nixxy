{lib, ...}: {
  options.nix-files = {
    user = lib.mkOption {
      description = ''
        Username of the system user
      '';
      type = lib.types.str;
      example = lib.literalExample "nerowy";
      default = "different";
    };
  };
}
