{
  flake.nixosModules = {
    # Module that contains nix expressions specific to this
    # config / my use case that I don't have plans to upstream
    nix-files = import ./nix-files;
  };
}
