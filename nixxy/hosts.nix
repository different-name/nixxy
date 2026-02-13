{
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  inherit (lib) types;

  cfg = config.nixxy;

  allClasses = lib.concatMap lib.attrsToList [
    cfg.systemClasses
    cfg.homeClasses
  ];

  nixxyModule = types.submoduleWith {
    description = "Nixxy module";
    class = "nixxy";
    specialArgs = { inherit inputs self; };

    modules = [
      (
        { name, ... }:
        let
          host = cfg.hosts.${name} or (throw "No '${name}' host found");
          # using custom defined inputs' and self' as using `withSystem` causes infinite recursion
          inputs' = lib.mapAttrs (_: lib.mapAttrs (_: v: v.${host.system} or v)) inputs;
          self' = inputs'.self;
        in
        {
          _module.args = { inherit inputs' self'; };
        }
      )

      {
        options = lib.listToAttrs (
          map (
            { name, value }:
            lib.nameValuePair value.namespace (
              lib.mkOption {
                type = with lib.types; coercedTo raw lib.toList (listOf raw);
                default = [ ];
                description = "Configuration modules to be imported by ${name}";
                example = lib.literalExpression "{ programs.example.enable = true; }";
              }
            )
          ) allClasses
        );
      }
    ];
  };

  hostUsers = lib.mapAttrs (
    hostAttr: _: lib.filterAttrs (_: user: lib.hasAttr hostAttr user.hosts) cfg.users
  ) cfg.hosts;
in
{
  options.nixxy = {
    hosts = lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            system = lib.mkOption {
              type = types.str;
              description = "The architecture of this host";
              example = "x86_64-linux";
            };

            class = lib.mkOption {
              type = types.str;
              description = "The class of this host";
              example = "nixos";
            };
          };
        }
      );
      default = { };
      description = "Host hardware information";
      # TODO documentation
    };

    finalHostConfigs = lib.mkOption {
      type = types.attrsOf nixxyModule;
      default = lib.mapAttrs (hostAttr: _: {
        imports =
          lib.concatMap (user: [
            user.hosts.${hostAttr}
            user.shared
          ]) (lib.attrValues hostUsers.${hostAttr})
          ++ [ cfg.shared ];
      }) cfg.hosts;
      internal = true;
      visible = false;
      readOnly = true;
      # TODO documentation
    };

    finalUserConfigs = lib.mkOption {
      type = types.attrsOf (types.attrsOf nixxyModule);
      default = lib.mapAttrs (
        hostAttr: _:
        lib.mapAttrs (_: user: {
          imports = [
            user.hosts.${hostAttr}
            user.shared
            cfg.shared
          ];
        }) hostUsers.${hostAttr}
      ) cfg.hosts;
      internal = true;
      visible = false;
      readOnly = true;
      # TODO documentation
    };
  };
}
