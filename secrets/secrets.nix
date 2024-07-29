let
  userKeys = [
    # sodium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
    # potassium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYQZq3ACrl2fg5pMh8YvErhigZgzOTrC/XiCk7li1tP root@potassium"
  ];

  rootKeys = [
    # sodium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium"
    # potassium
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmh/7dgdq32eSKcp6kwN28UF+PuyKJmvFRZKKUnyvf0 different@potassium"
  ];

  keys = userKeys ++ rootKeys;
in {
  # EDITOR="nano" nix run github:ryantm/agenix -- -e xxx/xxx.age
  # nix run github:ryantm/agenix -- -r
  "user/password.age".publicKeys = keys;
  "restic/password.age".publicKeys = keys;
  "restic/protondrive/rclone.conf.age".publicKeys = keys;
}
