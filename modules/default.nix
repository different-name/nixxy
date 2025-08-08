{ lib, ... }:
let
  isImportable =
    path: pathType:
    (pathType == "directory" && lib.pathExists (lib.path.append path "default.nix"))
    || (pathType == "regular" && lib.hasSuffix ".nix" path);

  kebabToSnakeCase =
    string:
    let
      words = lib.splitString "-" string;
      wordsToSnakeCase = pos: word: if pos > 1 then lib.toSentenceCase word else word;
    in
    lib.concatImapStrings wordsToSnakeCase words;

  importModules =
    dir:
    builtins.readDir dir
    |> lib.filterAttrs (name: pathType: isImportable (lib.path.append dir name) pathType)
    |> lib.mapAttrs' (
      name: _: {
        name = kebabToSnakeCase (lib.removeSuffix ".nix" name);
        value = import (lib.path.append dir name);
      }
    );

  moduleTypes =
    builtins.readDir ./. |> lib.filterAttrs (_: pathType: pathType == "directory") |> lib.attrNames;
in
{
  imports = map (moduleType: {
    flake."${moduleType}Modules" = importModules ./${moduleType};
  }) moduleTypes;
}
