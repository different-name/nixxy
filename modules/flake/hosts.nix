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

  # https://github.com/nix-community/disko/blob/master/docs/disko-install.md#example-for-a-nixos-installer
  diskoInstallModule =
    host:
    { self, pkgs, ... }:
    let
      dependencies =
        let
          inherit (self.nixosConfigurations.${host.hostName}) config pkgs;
        in
        [
          config.system.build.toplevel
          config.system.build.diskoScript
          config.system.build.diskoScript.drvPath
          pkgs.stdenv.drvPath

          # https://github.com/NixOS/nixpkgs/blob/f2fd33a198a58c4f3d53213f01432e4d88474956/nixos/modules/system/activation/top-level.nix#L342
          pkgs.perlPackages.ConfigIniFiles
          pkgs.perlPackages.FileSlurp

          (pkgs.closureInfo { rootPaths = [ ]; }).drvPath
        ]
        ++ map (input: input.outPath) (lib.attrValues self.inputs);

      closureInfo = pkgs.closureInfo { rootPaths = dependencies; };

      inherit (config.flake.nixosConfigurations.${host.hostName}.config.disko.devices) disk;
    in
    {
      environment = {
        etc."install-closure".source = "${closureInfo}/store-paths";

        systemPackages = lib.singleton (
          pkgs.writeShellScriptBin "install-nixos-unattended" ''
            set -eux
            exec ${lib.getExe' pkgs.disko "disko-install"} --flake "${self}#${host.hostName}" --disk main "${disk.main.device}"
          ''
        );
      };
    };
in
{
  options.nix-files.hosts = lib.mkOption {
    type = types.attrsOf (
      types.submodule (
        { name, ... }:
        {
          options = {
            hostName = lib.mkOption {
              type = types.str;
              description = "The architecture of the host";
              default = name;
              example = "sodium";
            };

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
      )
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs' (_: host: {
    name = host.hostName;
    value = inputs.nixpkgs.lib.nixosSystem (
      withSystem host.system (
        { self', inputs', ... }:
        {
          specialArgs = { inherit inputs self; };

          modules =
            lib.singleton (
              { lib, ... }:
              {
                _module.args = { inherit self' inputs'; };

                networking = {
                  inherit (host) hostName;
                  hostId = lib.substring 0 8 host.machine-id;
                };

                environment.etc.machine-id.text = host.machine-id;
              }
            )
            ++ host.modules;
        }
      )
    );
  }) config.nix-files.hosts;

  config.flake.packages = lib.mkMerge (
    lib.mapAttrsToList (_: host: {
      ${host.system}."${host.hostName}-installer" = inputs.nixos-generators.nixosGenerate {
        inherit (host) system;
        format = "install-iso";
        specialArgs = { inherit self; };
        modules = [
          (diskoInstallModule host)
          {
            # default to the current state version for the iso
            system.stateVersion = lib.versions.majorMinor inputs.nixpkgs.lib.version;
          }
        ];
      };
    }) config.nix-files.hosts
  );
}
