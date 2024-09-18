{config, ...}: {
  services.goxlr-utility.enable = true;

  # Add goxlr mic profile to each user's mic profiles
  home-manager.users = let
    normalUsers =
      builtins.filter
      (username: config.users.users.${username}.isNormalUser)
      (builtins.attrNames config.users.users);
  in
    builtins.listToAttrs (
      map (
        username: {
          name = username;
          value = {
            home.file.".local/share/goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
              source = ./procaster.goxlrMicProfile;
            };
          };
        }
      )
      normalUsers
    );
}
