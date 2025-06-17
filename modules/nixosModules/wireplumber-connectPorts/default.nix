{
  config,
  lib,
  ...
}:
let
  cfg = config.services.pipewire.wireplumber.connectPorts;
in
{
  options.services.pipewire.wireplumber = {
    connectPorts = lib.mkOption {
      default = [ ];
      description = "list of port auto-connection rules based on port aliases";

      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            output = {
              constraint = lib.mkOption {
                type = lib.types.str;
                description = "Constraint to apply when matching port aliases";
                example = "GoXLR:monitor_*";
              };

              leftAlias = lib.mkOption {
                type = lib.types.str;
                description = "Alias of the left port";
                example = "GoXLR:monitor_FL";
              };

              rightAlias = lib.mkOption {
                type = lib.types.str;
                description = "Alias of the right port";
                example = "GoXLR:monitor_FR";
              };
            };

            input = {
              constraint = lib.mkOption {
                type = lib.types.str;
                description = "Constraint to apply when matching port aliases";
                example = "WiVRn:playback_*";
              };

              leftAlias = lib.mkOption {
                type = lib.types.str;
                description = "Alias of the left port";
                example = "WiVRn:playback_1";
              };

              rightAlias = lib.mkOption {
                type = lib.types.str;
                description = "Alias of the right port";
                example = "WiVRn:playback_2";
              };
            };
          };
        }
      );
    };
  };

  config.services.pipewire.wireplumber = lib.mkIf (cfg != [ ]) {
    extraConfig."99-auto-connect-ports" = {
      "wireplumber.components" = [
        {
          name = "test/auto-connect-ports.lua";
          type = "script/lua";
          provides = "custom.auto-connect-ports";
        }
      ];

      "wireplumber.profiles" = {
        main = {
          "custom.auto-connect-ports" = "required";
        };
      };
    };

    extraScripts."test/auto-connect-ports.lua" =
      let
        autoConnectScript = builtins.readFile ./auto-connect-ports.lua;

        genAutoConnectFunction = ports: ''
          auto_connect_ports {
            output = Constraint { "port.alias", "matches", "${ports.output.constraint}" },
            input = Constraint { "port.alias", "matches", "${ports.input.constraint}" },
            connect = {
              ["${ports.output.leftAlias}"] = "${ports.input.leftAlias}",
              ["${ports.output.rightAlias}"] = "${ports.input.rightAlias}"
            }
          }
        '';

        autoConnectFunctions = cfg |> map genAutoConnectFunction |> lib.concatStrings;
      in
      autoConnectScript + autoConnectFunctions;
  };
}
