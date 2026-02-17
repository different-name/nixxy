{ lib, inputs, ... }:
let
  diffyHosts = [
    "sodium"
    "potassium"
    "iodine"
    "chinchilla"
  ];
in
{
  bundle = {
    hosts = lib.genAttrs diffyHosts (_: {
      system = "x86_64-linux";
      class = "nixos";
    });

    users.diffy = {
      shared.imports = lib.singleton (inputs.import-tree ./users/diffy/shared);

      hosts = lib.genAttrs diffyHosts (host: {
        imports = lib.singleton (inputs.import-tree ./users/diffy/hosts/${host});
      });
    };
  };
}
