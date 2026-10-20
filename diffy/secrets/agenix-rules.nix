# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  inherit ((import ../keys.nix).users) diffy;

  hosts = { inherit (diffy) argon potassium sodium; };

  desktops = [
    hosts.potassium
    hosts.sodium
  ];
  allHosts = builtins.attrValues hosts;
in
{
  # keep-sorted start
  "claude/instructions.age".publicKeys = desktops;
  "cloudflare/dns-token.age".publicKeys = allHosts;
  "firefox/policies.age".publicKeys = desktops;
  "tokens/nix-access-tokens.age".publicKeys = allHosts;
  "tokens/nixpkgs-review.age".publicKeys = desktops;
  "user-passwords/diffy.age".publicKeys = allHosts;
  "webdav/seedvault.age".publicKeys = allHosts;
  # keep-sorted end
}
