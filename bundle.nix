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
  imports = [
    inputs.bundle.flakeModules.default
  ];

  bundle = {
    hosts = lib.genAttrs diffyHosts (_: {
      system = "x86_64-linux";
      systemPlatform = "nixos";
    });

    users.diffy = {
      shared.imports = [ (inputs.import-tree ./diffy/shared) ];

      hosts = lib.genAttrs diffyHosts (host: {
        imports = [ (inputs.import-tree ./diffy/hosts/${host}) ];
      });
    };
  };
}
