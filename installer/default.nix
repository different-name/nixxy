{
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
  machineId = "c8efca59c8639eedca267bb34372a680";
in
{
  flake.packages.${system}.installer-iso = inputs.nixos-generators.nixosGenerate (
    withSystem system (
      { self', inputs', ... }:
      {
        inherit system;
        format = "iso";
        specialArgs = { inherit inputs self; };

        modules = [
          # keep-sorted start
          self.nixosModules.dyad
          self.nixosModules.tty1Autologin
          # keep-sorted end

          {
            _module.args = { inherit self' inputs'; };

            networking = {
              hostName = "installer";
              hostId = lib.substring 0 8 machineId;
            };

            environment.etc.machine-id.text = machineId;
          }

          (
            { config, ... }:
            {
              system.stateVersion = "24.05";

              dyad = {
                profiles = {
                  # keep-sorted start
                  graphical-minimal.enable = true;
                  minimal.enable = true;
                  terminal.enable = true;
                  # keep-sorted end
                };

                # keep-sorted start block=yes newline_separated=yes
                hardware.nvidia.enable = true;

                system = {
                  # keep-sorted start
                  boot.enable = lib.mkForce false;
                  home-manager.enable = true;
                  # keep-sorted end
                };
                # keep-sorted end
              };

              services.tty1Autologin = {
                enable = true;
                user = "silly";
              };

              users.users.silly = {
                isNormalUser = true;
                initialPassword = "nixos";

                openssh.authorizedKeys.keys = [
                  # keep-sorted start
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD diffy@potassium"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJgwHkHZhWjbZdto1j13LZ2KU8CljqLsTkXYKHK4Qurc diffy@pico"
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1 diffy@s23u"
                  # keep-sorted end
                ];

                extraGroups = [
                  # keep-sorted start
                  "audio"
                  "dialout"
                  "input"
                  "libvirtd"
                  "networkmanager"
                  "video"
                  "wheel"
                  # keep-sorted end
                ];
              };

              home-manager.users.silly = {
                imports = [
                  self.homeModules.dyad
                ];

                home = {
                  username = "silly";
                  homeDirectory = "/home/silly";
                  inherit (config.system) stateVersion;
                };

                dyad.profiles = {
                  # keep-sorted start
                  graphical-minimal.enable = true;
                  terminal.enable = true;
                  # keep-sorted end
                };
              };
            }
          )
        ];
      }
    )
  );
}
