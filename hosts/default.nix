{ inputs, ... }:
{
  imports = [
    ../modules/flake/hosts.nix
  ];

  nix-files.hosts = {
    # keep-sorted start block=yes newline_separated=yes
    iodine = {
      system = "x86_64-linux";
      machine-id = "294b0aee9a634611a9ddef5e843f4035";
      modules = [ (inputs.import-tree ./iodine) ];
    };

    potassium = {
      system = "x86_64-linux";
      machine-id = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
      modules = [ (inputs.import-tree ./potassium) ];
    };

    sodium = {
      system = "x86_64-linux";
      machine-id = "9471422d94d34bb8807903179fb35f11";
      modules = [ (inputs.import-tree ./sodium) ];
    };
    # keep-sorted end
  };
}
