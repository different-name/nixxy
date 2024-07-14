{...}: {
  # nh is a nix cli helper, useful for rebuilding & cleaning
  programs.nh = {
    enable = true;

    # nh default flake
    flake = "/home/different/nix-files";

    # weekly garbage collection
    clean = {
      enable = true;
      # keep configs from last 30 days
      extraArgs = "--keep-since 30d";
    };
  };
}
