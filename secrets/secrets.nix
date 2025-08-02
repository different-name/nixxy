# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  hosts = {
    # keep-sorted start
    iodine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5oCKpegl9IQDVehuGxvlSJTIkHy9Xr7myC9l2KJg2r diffy@iodine";
    potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNtFP6sku6bgMrh8fmmnuikTxObmbiRLFGQOIcm5+KD diffy@potassium";
    sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium";
    # keep-sorted end
  };

  allHosts = builtins.attrValues hosts;
in
{
  # keep-sorted start
  "copyparty/diffy.age".publicKeys = [ hosts.iodine ];
  "copyparty/nero.age".publicKeys = [ hosts.iodine ];
  "maocraft-discordsrv.age".publicKeys = [ hosts.iodine ];
  "syncthing/potassium/cert.age".publicKeys = [ hosts.potassium ];
  "syncthing/potassium/key.age".publicKeys = [ hosts.potassium ];
  "syncthing/sodium/cert.age".publicKeys = [ hosts.sodium ];
  "syncthing/sodium/key.age".publicKeys = [ hosts.sodium ];
  "tokens/cloudflare.age".publicKeys = allHosts;
  "tokens/github.age".publicKeys = allHosts;
  "user-passwords/diffy.age".publicKeys = allHosts;
  # keep-sorted end
}
