{ inputs, ... }:
{
  nix-files.hosts = {
    # keep-sorted start block=yes newline_separated=yes
    chinchilla = {
      system = "x86_64-linux";
      machine-id = "7047404f861348299434d987ffcd50b2";
      modules = [ (inputs.import-tree ./chinchilla) ];
    };

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
