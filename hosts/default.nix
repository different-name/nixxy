{
  nixxy = {
    hosts.sodium = {
      system = "x86_64-linux";
      class = "nixos";
    };

    users.diffy.hosts.sodium =
      { inputs, self, ... }:
      {
        nixos.imports = [
          (inputs.import-tree ./sodium)
        ];

        hm =
          { osConfig, ... }:
          {
            imports = [
              self.homeModules.dyad
            ];

            home = {
              username = "diffy";
              homeDirectory = "/home/diffy";
              inherit (osConfig.system) stateVersion;
            };

            dyad.system.agenix.enable = true;
          };
      };
  };
}
