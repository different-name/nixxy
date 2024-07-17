{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  specialArgs = {inherit inputs self;};
in {
  flake.nixosConfigurations = {
    "sodium" = nixosSystem {
      inherit specialArgs;
      modules = [./sodium];
    };
    "lithium" = nixosSystem {
      inherit specialArgs;
      modules = [./lithium];
    };
    "potassium" = nixosSystem {
      inherit specialArgs;
      modules = [./potassium];
    };
  };
}
