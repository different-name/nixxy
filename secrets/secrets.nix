# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  keys.users = {
    different.hosts = {
      potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD different@potassium";
      sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium";
    };
  };

  userKeys = username: builtins.attrValues keys.users.${username}.hosts;
  userHostKey = username: hostName: [ keys.users.${username}.hosts.${hostName} ];
in
{
  "different/user-password.age".publicKeys = userKeys "different";

  "different/tokens/github.age".publicKeys = userKeys "different";
  "different/tokens/cloudflare.age".publicKeys = userKeys "different";

  "different/maocraft-discordsrv.age".publicKeys = userKeys "different";

  "different/syncthing/sodium/key.age".publicKeys = userHostKey "different" "sodium";
  "different/syncthing/sodium/cert.age".publicKeys = userHostKey "different" "sodium";

  "different/syncthing/potassium/key.age".publicKeys = userHostKey "different" "potassium";
  "different/syncthing/potassium/cert.age".publicKeys = userHostKey "different" "potassium";
}
