# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  keys.users = {
    # keep-sorted start block=yes newline_separated=yes
    diffy.hosts = {
      # keep-sorted start
      iodine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5oCKpegl9IQDVehuGxvlSJTIkHy9Xr7myC9l2KJg2r diffy@iodine";
      potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD diffy@potassium";
      sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium";
      # keep-sorted end
    };
    # keep-sorted end
  };

  userKeys = username: builtins.attrValues keys.users.${username}.hosts;
  userHostKey = username: hostName: [ keys.users.${username}.hosts.${hostName} ];
in
{
  # keep-sorted start
  "diffy/copyparty/diffy.age".publicKeys = userHostKey "diffy" "iodine";
  "diffy/copyparty/nero.age".publicKeys = userHostKey "diffy" "iodine";
  "diffy/maocraft-discordsrv.age".publicKeys = userHostKey "diffy" "iodine";
  "diffy/syncthing/potassium/cert.age".publicKeys = userHostKey "diffy" "potassium";
  "diffy/syncthing/potassium/key.age".publicKeys = userHostKey "diffy" "potassium";
  "diffy/syncthing/sodium/cert.age".publicKeys = userHostKey "diffy" "sodium";
  "diffy/syncthing/sodium/key.age".publicKeys = userHostKey "diffy" "sodium";
  "diffy/tokens/cloudflare.age".publicKeys = userKeys "diffy";
  "diffy/tokens/github.age".publicKeys = userKeys "diffy";
  "diffy/user-password.age".publicKeys = userKeys "diffy";
  # keep-sorted end
}
