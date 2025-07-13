{
  devSearchPaths = [
    "/home/diffy/Code/my-moonlight-extensions/dist"
  ];
  extensions = {
    alwaysShowForwardTime = true;
    betterCodeblocks = true;
    betterEmbedsYT = true;
    callIdling = true;
    callTimer = true;
    clearUrls = true;
    cloneExpressions = true;
    colorConsistency = true;
    copyAvatarUrl = true;
    copyWebp = true;
    disableSentry = true;
    freeMoji = true;
    freeScreenShare = true;
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
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha-red.theme.css"
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
    noHelp = true;
    noJoinMessageWave = true;
    noMaskedLinkPaste = true;
    noReplyChainNag = true;
    noRpc = true;
    noTrack = true;
    openExternally = {
      config = {
        spotify = false;
      };
      enabled = true;
    };
    ownerCrown = true;
    platformStyles = {
      config = {
        noMinimumSize = true;
      };
      enabled = true;
    };
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
    whoJoined = {
      config = {
        serverNicknames = false;
      };
      enabled = true;
    };
  };
  repositories = [
    "https://moonlight-mod.github.io/extensions-dist/repo.json"
  ];
}
