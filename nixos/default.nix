{lib, ...}: {
  options.nix-files.host = lib.mkOption {
    description = "config host";
    type = lib.types.str;
  };
}
