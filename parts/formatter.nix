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
          # keep-sorted start
          "*.age"
          "_sources/generated.json"
          "_sources/generated.nix"
          # keep-sorted end
        ];

        programs = {
          # keep-sorted start block=yes newline_separated=yes
          deadnix.enable = true;

          keep-sorted = {
            enable = true;
            includes = [ "*" ];
          };

          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };

          prettier = {
            enable = true;
            package = pkgs.prettierd;
            settings.editorconfig = true;
          };

          shellcheck.enable = true;

          shfmt = {
            enable = true;
            indent_size = 2;
          };

          statix.enable = true;

          stylua.enable = true;
          # keep-sorted end
        };
      };
    };
}
