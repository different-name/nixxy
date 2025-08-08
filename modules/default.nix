{ lib, ... }:
let
  isImportable =
    path: type:
    (type == "directory" && lib.pathExists (lib.path.append path "default.nix"))
    || (type == "regular" && lib.hasSuffix ".nix" path);

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
    |> lib.filterAttrs (name: type: isImportable (lib.path.append dir name) type)
    |> lib.mapAttrs' (
      name: _: {
        name = kebabToSnakeCase (lib.removeSuffix ".nix" name);
        value = import (lib.path.append dir name);
      }
    );

  genModuleAttrs = type: {
    flake."${type}Modules" = importModules ./${type};
  };
in
{
  imports = map genModuleAttrs [
    "flake"
    "home"
    "nixos"
  ];
}
