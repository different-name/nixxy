{
  lib,
  config,
  inputs,
  self,
  withSystem,
  ...
}:
let
  inherit (lib) types;

  cfg = config.nixxy;

  genPrimeArgs =
    system:
    withSystem system (
      { inputs', self', ... }:
      {
        inherit inputs' self';
      }
    );

  deconstructedConfigData = lib.mapAttrsToList (
    hostAttr: host:
    let
      class = cfg.systemClasses.${host.class} or (throw "No '${host.class}' system class found");
      finalConfig = cfg.finalHostConfigs.${hostAttr};

      validHomeClasses = lib.filter (
        homeClass:
        (lib.hasAttr host.class homeClass.systemClasses) && (finalConfig.${homeClass.namespace} != [ ])
      ) (lib.attrValues cfg.homeClasses);

      homeConfigs =
        let
          transposeItem =
            child: parent: value:
            lib.singleton { inherit child parent value; };

          transposeItems = parent: lib.mapAttrsToList (transposeItem parent);

          deconstruct = lib.mapAttrsToList transposeItems;

          reconstruct = lib.foldl (
            acc: item:
            acc
            // {
              ${item.parent} = (acc.${item.parent} or { }) // {
                ${item.child} = item.value;
              };
            }
          ) { };

          transpose =
            attrs:
            lib.pipe attrs [
              deconstruct
              lib.flatten
              reconstruct
            ];
        in
        transpose cfg.finalUserConfigs.${hostAttr};

      finalHomeModules = lib.concatMap (
        homeClass:
        let
          systemClassCfg = homeClass.systemClasses.${host.class};
          systemModule = systemClassCfg.module;
          inherit (systemClassCfg) attrPath;

          userConfigs = homeConfigs.${homeClass.namespace};
          mappedHomeModules = lib.concatLists (
            lib.mapAttrsToList (
              userAttr: homeModules:
              map (homeModule: lib.setAttrByPath (attrPath ++ [ userAttr ]) homeModule) homeModules
            ) userConfigs
          );
        in
        [ systemModule ] ++ mappedHomeModules
      ) validHomeClasses;

      modules = finalConfig.${class.namespace} ++ finalHomeModules;
    in
    {
      ${class.flakeAttribute}.${hostAttr} = {
        inherit (class) mkSystem;

        args = {
          specialArgs = { inherit inputs self; };
          modules = [ { _module.args = genPrimeArgs host.system; } ] ++ modules;
        };
      };
    }
  ) cfg.hosts;

  configurationData = lib.foldl lib.recursiveUpdate { } deconstructedConfigData;

  configurations = lib.mapAttrs (
    _: hosts: lib.mapAttrs (_: { mkSystem, args }: mkSystem args) hosts
  ) configurationData;
in
{
  imports = [
    ./classes.nix
    ./hosts.nix
    ./users.nix
  ];

  options.nixxy = {
    shared = lib.mkOption {
      type = types.deferredModule; # would be nice if we could type this, but i'm not sure how to since nixxyModule needs access to system
      default = { };
      # TODO documentation
    };
  };

  config.flake = configurations;
}
