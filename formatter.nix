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
          "*.age"
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
            package = pkgs.nixfmt;
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

          statix = {
            enable = true;
            disabled-lints = [
              # TODO remove after new statix release
              # see https://github.com/oppiliappan/statix/issues/109#issuecomment-3092313521
              "faster_zipattrswith"
            ];
          };
          # keep-sorted end
        };
      };
    };
}
