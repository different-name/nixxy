{
  devSearchPaths = [
    "/home/diffy/Code/my-moonlight-extensions/dist"
  ];
  extensions = {
    alwaysFocus = true;
    alwaysShowForwardTime = true;
    betterCodeblocks = true;
    betterEmbedsYT = true;
    betterTags = true;
    callIdling = true;
    callTimer = true;
    clearUrls = true;
    cloneExpressions = true;
    colorConsistency = true;
    copyAvatarUrl = true;
    copyWebp = true;
    disableSentry = true;
    domOptimizer = true;
    doubleClickActions = true;
    favouriteGifSearch = true;
    freeMoji = true;
    freeScreenShare = true;
    freeStickers = true;
    hideBlocked = {
      config = {
        ignored = true;
      };
      enabled = true;
    };
    imageViewer = true;
    jumpToBlocked = true;
    mediaTweaks = {
      config = {
        imageUrls = false;
        noGifAutosend = false;
        noStickerAutosend = false;
        videoMetadata = false;
      };
      enabled = true;
    };
    memberCount = true;
    mentionAvatars = true;
    moonbase = {
      config = {
        updateBanner = true;
        updateChecking = true;
      };
      enabled = true;
    };
    moonlight-css = {
      config = {
        paths = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"
          "~/.local/share/disblock-origin/theme.css"
        ];
      };
      enabled = true;
    };
    nativeFixes = {
      config = {
        disableRendererBackgrounding = false;
        linuxSpeechDispatcher = true;
        vulkan = true;
      };
      enabled = true;
    };
    neatSettingsContext = true;
    noHelp = true;
    noJoinMessageWave = true;
    noMaskedLinkPaste = true;
    noReplyChainNag = true;
    noRpc = true;
    noTrack = true;
    onePingPerDM = {
      config = {
        allowAtEveryoneBypass = true;
        allowMentionsBypass = true;
        typeOfDM = "group_dm";
      };
      enabled = true;
    };
    openExternally = {
      config = {
        spotify = false;
      };
      enabled = true;
    };
    ownerCrown = true;
    platformIcons = {
      config = {
        messages = true;
      };
      enabled = false;
    };
    platformStyles = {
      config = {
        noMinimumSize = true;
      };
      enabled = true;
    };
    removeTopBar = true;
    replyChain = true;
    resolver = true;
    sendTimestamps = true;
    showAllRoles = true;
    showMediaOptions = true;
    showReplySelf = true;
    staffTags = {
      config = {
        tags = [
          {
            color = 5793266;
            icon = "crown";
            label = "Owner";
            permissions = [
              "OWNER"
            ];
            useRoleColor = true;
          }
          {
            color = 5793266;
            icon = "shield";
            label = "Admin";
            permissions = [
              "ADMINISTRATOR"
            ];
            useRoleColor = true;
          }
          {
            color = 5793266;
            icon = "wrench";
            label = "Manager";
            permissions = [
              "MANAGE_CHANNELS"
              "MANAGE_GUILD"
              "MANAGE_ROLES"
            ];
            useRoleColor = true;
          }
          {
            color = 5793266;
            icon = "hammer";
            label = "Mod";
            permissions = [
              "KICK_MEMBERS"
              "BAN_MEMBERS"
              "MUTE_MEMBERS"
              "DEAFEN_MEMBERS"
              "MOVE_MEMBERS"
              "MANAGE_NICKNAMES"
              "MODERATE_MEMBERS"
            ];
            useRoleColor = true;
          }
        ];
      };
      enabled = true;
    };
    svgEmbed = true;
    textReplacer = {
      config = {
        patterns = {
          "://x.com/" = "://girlcockx.com/";
        };
      };
      enabled = true;
    };
    typingTweaks = true;
    unindent = true;
    whoJoined = {
      config = {
        serverNicknames = false;
      };
      enabled = true;
    };
    whosWatching = false;
  };
  repositories = [
    "https://moonlight-mod.github.io/extensions-dist/repo.json"
  ];
}
