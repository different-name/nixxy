# hello <3
[group("↓ you are here")]
help:
  @just --list --unsorted --list-heading $'i wanna meet you in the middle!\n' --list-prefix "  "

[group("build")]
[private]
build command *args:
  @nh os {{ command }} --accept-flake-config {{ args }}

# add config to bootloader
[group("build")]
boot *args: (build "boot" args)

# add config to bootloader & power off
[group("build")]
goodnight update_flag="":
  @sudo true # to ask for password first
  @bash -c 'if [ "{{update_flag}}" = "-u" ]; then \
    cd sources && nvfetcher; \
    nix flake update; \
  fi'
  @timeout 5400 nh os boot || true # timeout after 1h 30m, continue regardless of output
  @poweroff # bye bye!

# activate and add config to bootloader
[group("build")]
switch *args: (build "switch" args)

# activate config
[group("build")]
test *args: (build "test" args)

# update flake inputs
[group("dependencies")]
update *args:
  @nix flake update {{ args }}

# update package sources
[group("dependencies")]
fetch *args:
  @cd sources && nvfetcher {{ args }}

# reformat code
[group("nice and tidy")]
fmt *args:
  @dyad-fmt {{ args }}

# clean all profiles
[group("nice and tidy")]
clean *args:
  @nh clean all --keep 5 {{ args }}

# load system in a repl
[group("tools")]
repl *args:
  @nh os repl {{ args }}

# load flake in a repl
[group("tools")]
flake-repl *args:
  @dyad-flake-repl {{ args }}
