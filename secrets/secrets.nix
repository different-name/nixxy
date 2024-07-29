let
  userKeys = [
    # sodium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
  ];

  rootKeys = [
    # sodium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium"
  ];

  keys = userKeys ++ rootKeys;
in {
  # EDITOR="nano" nix run github:ryantm/agenix -- -e xxx/xxx.age
  "user/password.age".publicKeys = keys;
  "restic/password.age".publicKeys = keys;
  "restic/protondrive/rclone.conf.age".publicKeys = keys;
}
