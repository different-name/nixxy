let
  keys = {
    sodium = {
      root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium";
      different = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium";
    };

    potassium = {
      root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBYQZq3ACrl2fg5pMh8YvErhigZgzOTrC/XiCk7li1tP root@potassium";
      different = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmh/7dgdq32eSKcp6kwN28UF+PuyKJmvFRZKKUnyvf0 different@potassium";
    };

    iodine = {
      root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkkCK33jVJn/dSsrhc3zZIyzGZ6uaKwjIKCKyu0YVpm root@iodine";
      iodine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFgR+CwgIILS4vhO1VFCZwpek+MKMlA/rWZbWpPnPwz iodine@iodine";
    };
  };

  allKeys = let
    flatten = with builtins;
      x:
        if isList x
        then concatMap (y: flatten y) x
        else [x];
  in
    flatten (map
      (host: builtins.attrValues host)
      (builtins.attrValues keys));
in {
  # create/edit: nix run github:ryantm/agenix -- -e x.age
  # rekey:       nix run github:ryantm/agenix -- -r
  "user-pass/different.age".publicKeys = with keys; [
    sodium.different
    potassium.different
  ];
  "user-pass/iodine.age".publicKeys = with keys; [
    iodine.iodine
  ];

  "tokens/github.age".publicKeys = allKeys;
}
