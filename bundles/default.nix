{ lib, inputs, ... }:
let
  x86_64-linux = {
    system = "x86_64-linux";
    class = "nixos";
  };
in
{
  bundle = {
    hosts = {
      # keep-sorted start
      chinchilla = x86_64-linux;
      iodine = x86_64-linux;
      potassium = x86_64-linux;
      sodium = x86_64-linux;
      # keep-sorted end
    };

    users.diffy = {
      shared.imports = [
        (inputs.import-tree ./users/diffy/shared)
      ];

      hosts =
        lib.genAttrs
          [
            # keep-sorted start
            "chinchilla"
            "iodine"
            "potassium"
            "sodium"
            # keep-sorted end
          ]
          (host: {
            imports = [
              (inputs.import-tree ./users/diffy/hosts/${host})
            ];
          });
    };
  };
}
