# Imperative Workarounds

This is a list of workarounds that I could not reasonably perform declaratively

## Steam

### steam-game-wrapper

Some games require specific launch option workarounds, such as needing to unset the TZ environmental variable

This is managed through the NixOS Module [steam-launch-options](system/modules/steam-launch-options/default.nix), which provides `programs.steam.launchOptions`

To function, this requires steam-game-wrapper to be added to the launch options of each game like so:

```
steam-game-wrapper %command%
```