{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    specialArgs = {inherit inputs self;};
  in {
    "sodium" = nixosSystem {
      inherit specialArgs;
      modules = [./sodium ../.];
    };

    "potassium" = nixosSystem {
      inherit specialArgs;
      modules = [./potassium ../.];
    };

    "iodine" = nixosSystem {
      inherit specialArgs;
      modules = [./iodine ../.];
    };
  };
}
