{
  lib,
  config,
  self',
  ...
}:
let
  cfg = config.programs.disblockOrigin;

  disblockOriginSettings = {
    badges = {
      isBool = false;
      default = false;
      description = "Nitro and Booster badges on user profiles";
    };
    gif-button = {
      isBool = false;
      default = false;
      description = "GIF button in chat bar";
    };
    sticker-button = {
      isBool = false;
      default = false;
      description = "Sticker button in chat bar";
    };
    hover-reaction-emoji = {
      isBool = false;
      default = true;
      description = "Emoji suggestions on message hover";
    };
    app-launcher = {
      isBool = false;
      default = false;
      description = "App launcher right of chat bar";
    };
    super-reactions = {
      isBool = false;
      default = false;
      description = "Hide super reactions entirely";
    };
    super-reaction-hide-anim = {
      isBool = true;
      default = true;
      description = "Replace Super Reactions with a blink animation";
    };
    profile-effects = {
      isBool = false;
      default = false;
      description = "Avatar decorations & profile effects";
    };
    nameplates = {
      isBool = false;
      default = false;
      description = "Hide nameplates in the members list";
    };
    active-now = {
      isBool = false;
      default = true;
      description = "Active Now column in friends list";
    };
    clan-tags = {
      isBool = false;
      default = true;
      description = "Clan tags next to the usernames";
    };
    server-settings-boost-tab = {
      isBool = false;
      default = false;
      description = "Server settings menu Boost tab";
    };

    settings-billing-header = {
      isBool = false;
      default = true;
      description = "Settings menu Billing Settings header";
    };
    settings-nitro-tab = {
      isBool = false;
      default = false;
      description = "Settings menu Nitro tab";
    };
    settings-server-boost-tab = {
      isBool = false;
      default = false;
      description = "Settings menu Server Boost tab";
    };
    settings-subscriptions-tab = {
      isBool = false;
      default = false;
      description = "Settings menu Subscriptions tab";
    };
    settings-gift-inventory-tab = {
      isBool = false;
      default = true;
      description = "Settings menu Gift Inventory tab";
    };
    nitro-features = {
      isBool = false;
      default = false;
      description = "Settings menu Billing tab, Super React toggle, GIF Avatar";
    };
  };

  mkSetting =
    _name: setting:
    lib.mkOption {
      inherit (setting) description default;
      type = lib.types.bool;
    };

  settingToCss =
    name: value:
    let
      setting = disblockOriginSettings.${name};

      prefix = if setting.isBool then "bool" else "display";

      css-value =
        if setting.isBool then
          lib.boolToString value
        else if value then
          "unset"
        else
          "none";
    in
    "--${prefix}-${name}: ${css-value};";

  disblock-origin = self'.packages.disblock-origin;
in
{
  options.programs.disblockOrigin = {
    enable = lib.mkEnableOption "Disblock Origin";
    settings = lib.mapAttrs mkSetting disblockOriginSettings;
  };

  config = lib.mkIf cfg.enable {
    xdg.dataFile."disblock-origin/theme.css".text = ''
      ${builtins.readFile (disblock-origin + /share/DisblockOrigin.theme.css)}

      :root {
        ${cfg.settings |> lib.mapAttrsToList settingToCss |> lib.concatStringsSep "\n  "}
      }
    '';
  };
}
