{ lib, ... }:
let
  isImportable =
    path: pathType:
    (pathType == "directory" && lib.pathExists (lib.path.append path "default.nix"))
    || (pathType == "regular" && lib.hasSuffix ".nix" path);

  importModules =
    dir:
    lib.pipe dir [
      lib.readDir
      (lib.filterAttrs (name: pathType: isImportable (lib.path.append dir name) pathType))
      (lib.mapAttrs' (
        name: _: {
          name = lib.toCamelCase (lib.removeSuffix ".nix" name);
          value = import (lib.path.append dir name);
        }
      ))
    ];

  moduleTypes = lib.pipe ./. [
    lib.readDir
    (lib.filterAttrs (_: pathType: pathType == "directory"))
    lib.attrNames
  ];
in
{
  imports = map (moduleType: {
    flake."${moduleType}Modules" = importModules ./${moduleType};
  }) moduleTypes;
}
