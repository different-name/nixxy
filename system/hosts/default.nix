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
    "potassium" = nixosSystem {
      inherit specialArgs;
      modules = [./potassium];
    };
  };
}
