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
in
{
  options.nix-files.hosts = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          system = lib.mkOption {
            type = types.str;
            description = "The architecture of the host";
            example = "x86_64-linux";
          };

          machine-id = lib.mkOption {
            type = types.str // {
              check =
                v:
                let
                  isLowerHex = lib.match "^[0-9a-fA-F]+$" v != null;
                  isLength = lib.stringLength v == 32;
                in
                isLowerHex && isLength;
            };
            description = "The unique machine ID of the system, a single hexadecimal, 32-character, lowercase ID";
            example = "9471422d94d34bb8807903179fb35f11";
          };

          modules = lib.mkOption {
            type = types.listOf types.deferredModule;
            default = [ ];
            description = "Modules to be included in the system";
            example = lib.literalExample ''
              [ ./hardware-configuration.nix ]
            '';
          };
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    hostName: host:
    inputs.nixpkgs.lib.nixosSystem (
      withSystem host.system (
        { self', inputs', ... }:
        {
          specialArgs = { inherit inputs self; };

          modules =
            lib.singleton {
              _module.args = { inherit self' inputs'; };

              networking = {
                inherit hostName;
                hostId = lib.substring 0 8 host.machine-id;
              };

              environment.etc.machine-id.text = host.machine-id;
            }
            ++ host.modules;
        }
      )
    )
  ) config.nix-files.hosts;
}
