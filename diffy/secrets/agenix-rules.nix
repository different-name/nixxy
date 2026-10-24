# create/edit: nix run github:ryantm/agenix -- -e x.age
# rekey:       nix run github:ryantm/agenix -- -r
let
  keys = import ../keys.nix;

  # user keys on the desktops, so secrets stay editable there
  editors = with keys.users.diffy; [
    potassium
    sodium
  ];

  # system secrets decrypt with the host key of each machine that uses them
  hosts = names: editors ++ map (name: keys.hosts.${name}) names;
in
{
  # keep-sorted start block=yes
  "bone/catch-login.age".publicKeys = hosts [ "argon" ];
  "bone/catch-password.age".publicKeys = hosts [ "argon" ];
  "bone/device-lithium.age".publicKeys = hosts [ "argon" ];
  "bone/device-potassium.age".publicKeys = hosts [ "argon" ];
  "bone/device-sodium.age".publicKeys = hosts [ "argon" ];
  "bone/main-login.age".publicKeys = hosts [ "argon" ];
  "bone/main-password.age".publicKeys = hosts [ "argon" ];
  "claude/instructions.age".publicKeys = editors;
  "cloudflare/dns-token.age".publicKeys = hosts [ "argon" ];
  "firefox/policies.age".publicKeys = hosts [
    "potassium"
    "sodium"
  ];
  "mollysocket/env.age".publicKeys = hosts [ "argon" ];
  "opencloud/admin.age".publicKeys = hosts [ "argon" ];
  "opencloud/s3.age".publicKeys = hosts [ "argon" ];
  "radicale/htpasswd.age".publicKeys = hosts [ "argon" ];
  "restic/argon.age".publicKeys = hosts [ "argon" ];
  "restic/potassium.age".publicKeys = hosts [ "potassium" ];
  "restic/sodium.age".publicKeys = hosts [ "sodium" ];
  "tokens/nix-access-tokens.age".publicKeys = hosts [
    "argon"
    "potassium"
    "sodium"
  ];
  "tokens/nixpkgs-review.age".publicKeys = editors;
  "user-passwords/diffy.age".publicKeys = hosts [
    "argon"
    "potassium"
    "sodium"
  ];
  "webdav/seedvault.age".publicKeys = hosts [ "argon" ];
  # keep-sorted end
}
