{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) outputs;
  specialArgs = {inherit inputs outputs;};
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
