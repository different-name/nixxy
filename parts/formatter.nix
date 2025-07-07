{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    { pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      treefmt = {
        projectRootFile = "flake.nix";

        settings.global.excludes = [
          "_sources/generated.nix"
          "_sources/generated.json"
          "*.age"
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
            settings.editorconfig = true;
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
