{
  bundleLib,
  lib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "nix" "nix" ] {
  dyad.system.agenix.enable = true;

  nixos =
    { config, pkgs, ... }:
    {
      imports = [
        # weekly updated nix-index database
        # needed due to nix channels being disabled, breaking command-not-found
        # also used for comma: https://github.com/nix-community/comma
        inputs.nix-index-database.nixosModules.default
      ];

      config = {
        age.secrets."tokens/nix-access-tokens".file = self + /secrets/tokens/nix-access-tokens.age;

        # need git for flakes
        environment.systemPackages = [ pkgs.git ];

        nix =
          let
            flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
          in
          {
            # pin the registry to avoid downloading and evaling a new nixpkgs verison every time
            registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
            # set the path for channels compat
            nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

            settings = {
              experimental-features = "nix-command flakes";
              flake-registry = ""; # disable global registry

              # https://jackson.dev/post/nix-reasonable-defaults/
              connect-timeout = 5;
              min-free = 128000000;
              max-free = 1000000000;
              fallback = true;
              auto-optimise-store = true;
              warn-dirty = false;

              builders-use-substitutes = true;
            };

            # read-only github token for rate limit
            extraOptions = ''
              !include ${config.age.secrets."tokens/nix-access-tokens".path}
            '';

            channel.enable = false;
          };

        programs.nix-index-database.comma.enable = true;
      };
    };

  home-manager = {
    xdg.dataFile."nix/trusted-settings.json".text =
      let
        inherit (import "${self}/flake.nix") nixConfig;
      in
      lib.toJSON (
        lib.mapAttrs (_: list: {
          ${lib.concatStringsSep " " list} = true;
        }) nixConfig
      );

    home.perpetual.default = {
      dirs = [
        "$cacheHome/nix"
      ];
      files = [
        "$dataHome/nix/repl-history"
      ];
    };
  };
}
