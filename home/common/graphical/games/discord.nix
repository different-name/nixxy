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
    # to update config:
    # $ rm ~/.config/moonlight-mod/stable.json
    # save config in moonbase
    # $ nix repl
    # nix-repl> :p builtins.fromJSON (builtins.readFile ~/.config/moonlight-mod/stable.json)
    programs.moonlight-mod = {
      enable = true;
      configs.stable = {
        devSearchPaths = ["/home/different/Code/my-moonlight-extensions/dist"];
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
              paths = ["https://catppuccin.github.io/discord/dist/catppuccin-mocha-red.theme.css"];
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
            config = {spotify = false;};
            enabled = true;
          };
          ownerCrown = true;
          replyChain = true;
          resolver = true;
          sendTimestamps = true;
          showMediaOptions = true;
          showReplySelf = true;
          staffTags = {
            config = {
              tags = [
                {
                  color = 5793266;
                  icon = "crown";
                  label = "Owner";
                  permissions = ["OWNER"];
                  useRoleColor = true;
                }
                {
                  color = 5793266;
                  icon = "shield";
                  label = "Admin";
                  permissions = ["ADMINISTRATOR"];
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
            config = {serverNicknames = false;};
            enabled = true;
          };
        };
        repositories = ["https://moonlight-mod.github.io/extensions-dist/repo.json"];
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
