# hello <3
[group("↓ you are here")]
help:
  @just --list --unsorted --list-heading $'i wanna meet you in the middle!\n' --list-prefix "  "

[group("build")]
[private]
build command *args:
  @nh os {{ command }} {{ args }}

# add config to bootloader
[group("build")]
boot *args: (build "boot" args)

# add config to bootloader & power off
[group("build")]
goodnight:
  @sudo true # to ask for password first
  @nh os boot
  @poweroff

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

# bump dependencies
[group("dependencies")]
bump:
  @echo -e "\e[35m>\e[0m Updating package sources"
  @nvfetcher
  @echo -e "\n\e[32m>\e[0m Updating all flake inputs"
  @nix flake update

# reformat code
[group("nice and tidy")]
fmt *args:
  @nix fmt {{ args }}

# clean all profiles
[group("nice and tidy")]
clean *args:
  @nh clean all --keep 5 {{ args }}

# load system in a repl
[group("tools")]
repl *args:
  @nh os repl {{ args }}
