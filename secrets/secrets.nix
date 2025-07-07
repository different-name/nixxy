let
  keys = {
    sodium = {
      root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcwUucfJukMLcfKPpPnfzrw7lIIJFcwW/IxIIO6w8g7 root@sodium";
      different = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium";
    };

    potassium = {
      root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUx2TZSI1O5UyBFunUi93OX5jWy1F0reCCrn9jaU+ij root@potassium";
      different = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD different@potassium";
    };
  };

  flatten = x: if builtins.isList x then builtins.concatMap (y: flatten y) x else [ x ];
  allKeys = keys |> builtins.attrValues |> map (host: builtins.attrValues host) |> flatten;
in
{
  # create/edit: nix run github:ryantm/agenix -- -e x.age
  # rekey:       nix run github:ryantm/agenix -- -r
  "user-pass/different.age".publicKeys = with keys; [
    sodium.different
    potassium.different
  ];

  "tokens/github.age".publicKeys = allKeys;
  "tokens/cloudflare.age".publicKeys = allKeys;

  "syncthing/sodium/key.age".publicKeys = with keys.sodium; [
    root
    different
  ];
  "syncthing/sodium/cert.age".publicKeys = with keys.sodium; [
    root
    different
  ];

  "syncthing/potassium/key.age".publicKeys = with keys.potassium; [
    root
    different
  ];
  "syncthing/potassium/cert.age".publicKeys = with keys.potassium; [
    root
    different
  ];

  "minecraft/maocraft-discordsrv.age".publicKeys = allKeys;
}
