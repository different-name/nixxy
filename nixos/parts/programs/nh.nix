{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.nix-files.parts.programs.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.nix-files.parts.programs.nh.enable {
    # nh is a nix cli helper, useful for rebuilding & cleaning
    programs.nh = {
      enable = true;

      package = inputs.nh.packages.${pkgs.system}.nh.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (builtins.path {
            path = inputs.self + /patches/nh/add-nvfetcher.patch;
            name = "nh-add-nvfetcher";
          })
        ];

        postFixup = ''
          wrapProgram $out/bin/nh \
            --prefix PATH : ${
              lib.makeBinPath
              <| lib.attrValues {
                inherit (pkgs) nvd nix-output-monitor nvfetcher;
              }
            }
        '';
      });

      # weekly garbage collection
      clean = {
        enable = true;
        # keep configs from last 30 days
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
