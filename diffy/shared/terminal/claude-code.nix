{
  bundleLib,
  lib,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "terminal" "claude-code" ] {
  home-manager =
    { config, pkgs, ... }:
    let
      p = config.dyad.palette;
      accent = p.${config.catppuccin.accent};

      # blend two palette colours
      # t = 0: 100% a
      # t = 1: 100% b
      mix =
        a: b: t:
        let
          chan =
            c:
            lib.toLower (
              lib.fixedWidthString 2 "0" (
                lib.toHexString (builtins.floor (a.rgb.${c} + (b.rgb.${c} - a.rgb.${c}) * t + 0.5))
              )
            );
        in
        "#${chan "r"}${chan "g"}${chan "b"}";

      # shimmer variants are the base colour lightened toward rosewater
      shimmer = c: mix c p.rosewater 0.5;

      theme = (pkgs.formats.json { }).generate "catppuccin.json" {
        name = "Catppuccin ${lib.toSentenceCase config.catppuccin.flavor}";
        base = if config.catppuccin.flavor == "latte" then "light" else "dark";
        overrides = {
          # brand
          claude = p.peach.hex;
          claudeShimmer = p.rosewater.hex;
          claudeBlue_FOR_SYSTEM_SPINNER = p.blue.hex;
          claudeBlueShimmer_FOR_SYSTEM_SPINNER = p.lavender.hex;
          clawd_body = p.peach.hex;
          clawd_background = p.base.hex;
          briefLabelClaude = p.peach.hex;
          briefLabelYou = p.blue.hex;

          # modes and prompts
          autoAccept = accent.hex;
          autoAcceptShimmer = shimmer accent;
          skill = accent.hex;
          merged = accent.hex;
          effortUltra = accent.hex;
          remember = accent.hex;
          planMode = p.teal.hex;
          fastMode = p.peach.hex;
          fastModeShimmer = shimmer p.peach;
          permission = p.lavender.hex;
          permissionShimmer = shimmer p.lavender;
          bashBorder = p.pink.hex;
          ide = p.sapphire.hex;

          # text
          text = p.text.hex;
          inverseText = p.base.hex;
          inactive = p.overlay1.hex;
          inactiveShimmer = p.overlay2.hex;
          subtle = p.surface1.hex;
          suggestion = p.lavender.hex;
          promptBorder = p.surface2.hex;
          promptBorderShimmer = p.overlay1.hex;
          background = p.base.hex;

          # status
          success = p.green.hex;
          error = p.red.hex;
          warning = p.yellow.hex;
          warningShimmer = shimmer p.yellow;

          # diffs, tinted backgrounds rather than flat palette colours
          diffAdded = mix p.base p.green 0.22;
          diffRemoved = mix p.base p.red 0.22;
          diffAddedDimmed = mix p.base p.green 0.1;
          diffRemovedDimmed = mix p.base p.red 0.1;
          diffAddedWord = mix p.base p.green 0.45;
          diffRemovedWord = mix p.base p.red 0.45;

          # surfaces
          userMessageBackground = p.surface0.hex;
          userMessageBackgroundHover = p.surface1.hex;
          composerSidebarBackground = p.mantle.hex;
          selectionBg = mix p.base p.blue 0.3;
          bashMessageBackgroundColor = mix p.base p.pink 0.12;
          memoryBackgroundColor = mix p.base p.sapphire 0.12;
          rate_limit_fill = accent.hex;
          rate_limit_empty = p.surface1.hex;

          # subagent labels
          red_FOR_SUBAGENTS_ONLY = p.red.hex;
          blue_FOR_SUBAGENTS_ONLY = p.blue.hex;
          green_FOR_SUBAGENTS_ONLY = p.green.hex;
          yellow_FOR_SUBAGENTS_ONLY = p.yellow.hex;
          purple_FOR_SUBAGENTS_ONLY = p.mauve.hex;
          orange_FOR_SUBAGENTS_ONLY = p.peach.hex;
          pink_FOR_SUBAGENTS_ONLY = p.pink.hex;
          cyan_FOR_SUBAGENTS_ONLY = p.sky.hex;
          professionalBlue = p.sapphire.hex;
          chromeYellow = p.yellow.hex;

          # rainbow
          rainbow_red = p.red.hex;
          rainbow_orange = p.peach.hex;
          rainbow_yellow = p.yellow.hex;
          rainbow_green = p.green.hex;
          rainbow_blue = p.blue.hex;
          rainbow_indigo = p.lavender.hex;
          rainbow_violet = p.mauve.hex;
          rainbow_red_shimmer = shimmer p.red;
          rainbow_orange_shimmer = shimmer p.peach;
          rainbow_yellow_shimmer = shimmer p.yellow;
          rainbow_green_shimmer = shimmer p.green;
          rainbow_blue_shimmer = shimmer p.blue;
          rainbow_indigo_shimmer = shimmer p.lavender;
          rainbow_violet_shimmer = shimmer p.mauve;
        };
      };
    in
    {
      home.perpetual.default.packages.claude-code = {
        dirs = [
          "$cacheHome/claude-cli-nodejs"
          ".claude"
        ];
        files = [ ".claude.json" ];
      };

      home.file.".claude/themes/catppuccin.json".source = theme;

      age.secrets."claude/instructions" = {
        file = self + /secrets/claude/instructions.age;
        path = "${config.home.homeDirectory}/.claude/instructions.md";
      };

      home.file.".claude/CLAUDE.md".text = ''
        @${config.age.secrets."claude/instructions".path}
      '';
    };
}
