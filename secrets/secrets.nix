# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  hosts = {
    # keep-sorted start
    chinchilla = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXeKuGbHm4NQe3P/Gskdt75GnQccZLaQPN12lR+KEJp diffy@chinchilla";
    iodine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5oCKpegl9IQDVehuGxvlSJTIkHy9Xr7myC9l2KJg2r diffy@iodine";
    potassium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3EOgPFHT/t5cimzbfL/vEyolU4CbdT9HVMyp8PnTUG diffy@potassium";
    sodium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg diffy@sodium";
    # keep-sorted end
  };

  allHosts = builtins.attrValues hosts;
in
{
  # keep-sorted start
  "tokens/cloudflare.age".publicKeys = allHosts;
  "tokens/nix-access-tokens.age".publicKeys = allHosts;
  "user-passwords/diffy.age".publicKeys = allHosts;
  # keep-sorted end
}
