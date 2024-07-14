{inputs, ...}: {
  imports = [inputs.pre-commit-hooks-nix.flakeModule];

  perSystem.pre-commit = {
    settings.excludes = ["flake.lock"];

    settings.hooks = {
      alejandra.enable = true;
    };
  };
}
