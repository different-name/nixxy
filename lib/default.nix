{
  lib,
  ...
}:
{
  flake.lib = rec {
    # merge a list of attribute sets together using `lib.recursiveUpdate`
    mergeAttrsListRecursive = list: lib.foldl' lib.recursiveUpdate { } list;

    # recursively imports and merges a configuration file and all of its transitive `imports`,
    # excluding any modules that define `options` or `config`, which are not supported
    flattenImportTree =
      path: args:
      let
        rawImport = import path;
        baseConfig = if lib.isFunction rawImport then rawImport args else rawImport;
        rawConfig = (lib.removeAttrs baseConfig [ "imports" ]);

        subConfigs = map (path: flattenImportTree path args) (baseConfig.imports or [ ]);
        mergedConfig = mergeAttrsListRecursive ([ rawConfig ] ++ subConfigs);

        throwUnsupportedField =
          field: builtins.throw "'${path}' defines '${field}', which flattenImports does not support";
      in
      if baseConfig ? options then
        throwUnsupportedField "options"
      else if baseConfig ? config then
        throwUnsupportedField "config"
      else
        mergedConfig;

    # applies `flattenImportTree` to a list of inputs
    flattenImports =
      modules: args: modules |> map (module: flattenImportTree module args) |> mergeAttrsListRecursive;
  };
}
