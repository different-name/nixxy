{ inputs, ... }:
{
  imports = [
    ./configurations/hosts
    ./lib
    ./modules
    ./packages

    inputs.treefmt-nix.flakeModule
  ];

  systems = import inputs.systems;

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        settings.global.excludes = [
          "packages/_sources/*"
        ];

        programs = {
          shellcheck.enable = true;

          deadnix.enable = true;

          statix.enable = true;

          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };

          prettier = {
            enable = true;
            package = pkgs.prettierd;
            excludes = [ "*.age" ];
            settings = {
              editorconfig = true;
            };
          };

          stylua.enable = true;

          shfmt = {
            enable = true;
            indent_size = 2;
          };
        };
      };
    };
}
