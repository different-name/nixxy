{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.nixxy.users = lib.mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          shared = lib.mkOption {
            type = types.deferredModule;
            default = { };
            # TODO documentation
          };

          # TODO assert that hosts here must be defined in cfg.hosts
          hosts = lib.mkOption {
            type = types.attrsOf types.deferredModule;
            # TODO documentation
          };
        };
      }
    );
    default = { };
    description = ''
      User configuration, all configuration is applied through users

      Each user defined here represents a person (real user). These differ from users in the system itself (user account)

      A real user's configuration can create multiple user accounts if needed

      If you are the only one using your configuration, you would have only one real user
    '';
    # TODO documentation
  };
}
