{
  nixos = { lib, options, ... }: {
    config = lib.optionalAttrs (options ? home-manager) {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
  };
}
