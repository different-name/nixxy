{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.moonlight.homeModules.default
  ];

  options.nix-files.graphical.games.discord.enable = lib.mkEnableOption "Discord config";

  config = lib.mkIf config.nix-files.graphical.games.discord.enable {
    programs.moonlight-mod = {
      enable = true;

      configs.stable = {
        extensions = {
          # moonbase
          moonbase = {
            enabled = true;
            config = {
              updateChecking = true;
              updateBanner = true;
            };
          };

          # appearance
          colorConsistency = true;
          moonlight-css = {
            enabled = true;
            config = {
              paths = [
                "https://catppuccin.github.io/discord/dist/catppuccin-mocha-red.theme.css"
              ];
            };
          };

          # chat
          alwaysShowForwardTime = true;
          ownerCrown = true;
          betterCodeblocks = true;
          mentionAvatars = true;
          noJoinMessageWave = true;
          noMaskedLinkPaste = true;
          noReplyChainNag = true;
          replyChain = true;
          staffTags = true;
          showReplySelf = true;

          # commands
          sendTimestamps = true;

          # context menu
          copyAvatarUrl = true;
          copyWebp = true;
          resolver = true;
          showMediaOptions = true;

          # fixes
          nativeFixes = {
            config = {
              disableRendererBackgrounding = false;
              vulkan = true;
              linuxSpeechDispatcher = true;
            };
            enabled = true;
          };

          # privacy
          betterEmbedsYT = true;
          clearUrls = true;
          disableSentry = true;
          noHelp = true;
          noRpc = true;
          noTrack = true;

          # qol
          cloneExpressions = true;
          freeScreenShare = true;
          freeMoji = true;
          imageViewer = true;
          jumpToBlocked = true;
          mediaTweaks = {
            enabled = true;
            config = {
              imageUrls = false;
              videoMetadata = false;
              noStickerAutosend = false;
            };
          };
          openExternally = {
            enabled = true;
            config = {
              spotify = false;
            };
          };

          # voice
          callIdling = true;
          callTimer = true;
          whoJoined = {
            enabled = true;
            config = {
              serverNicknames = false;
            };
          };
        };

        repositories = [
          "https://moonlight-mod.github.io/extensions-dist/repo.json"
        ];
      };
    };

    home.packages = with pkgs; [
      (discord.override {withMoonlight = true;})
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/discord"
        ".config/moonlight-mod"
      ];
    };
  };
}
