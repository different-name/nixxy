{ config, lib, ... }:
let
  inherit (lib) types;

  cfg = config.services.pipewire.wireplumber.scripts;

  genScriptConfig =
    {
      name,
      script,
      scriptCfg,
      genFunctionCall,
    }:
    {
      extraConfig."99-${name}" = {
        "wireplumber.components" = lib.singleton {
          name = "test/${name}.lua";
          type = "script/lua";
          provides = "custom.${name}";
        };

        "wireplumber.profiles".main = {
          "custom.${name}" = "required";
        };
      };

      extraScripts."test/${name}.lua" = ''
        ${builtins.readFile script}
        ${scriptCfg |> map genFunctionCall |> lib.concatStringsSep "\n"}
      '';
    };
in
{
  options.services.pipewire.wireplumber.scripts = {
    autoConnectPorts = lib.mkOption {
      default = [ ];
      description = "A List of port auto-connection rules";

      type = types.listOf (
        types.submodule {
          options = {
            output = {
              subject = lib.mkOption {
                type = types.str;
                description = "The property to match using";
                example = "port.alias";
              };

              leftPort = lib.mkOption {
                type = types.str;
                description = "Left port object to match";
                example = "GoXLR:monitor_FL";
              };

              rightPort = lib.mkOption {
                type = types.str;
                description = "Right port object to match";
                example = "GoXLR:monitor_FR";
              };
            };

            input = {
              subject = lib.mkOption {
                type = types.str;
                description = "The property to match using";
                example = "port.alias";
              };

              leftPort = lib.mkOption {
                type = types.str;
                description = "Left port object to match";
                example = "WiVRn:playback_1";
              };

              rightPort = lib.mkOption {
                type = types.str;
                description = "Right port object to match";
                example = "WiVRn:playback_2";
              };
            };
          };
        }
      );
    };

    setNodeVolume = lib.mkOption {
      default = [ ];
      description = "A list of node volume rules";

      type = types.listOf (
        types.submodule {
          options = {
            subject = lib.mkOption {
              type = types.str;
              description = "The property to match using";
              example = "node.name";
            };

            object = lib.mkOption {
              type = types.str;
              description = "Object to match";
              example = "wivrn.source";
            };

            volume = lib.mkOption {
              type = types.float;
              description = "Default volume";
              example = "0.5";
            };
          };
        }
      );
    };
  };

  config.services.pipewire.wireplumber = lib.mkMerge [
    (lib.mkIf (cfg.autoConnectPorts != [ ]) (genScriptConfig {
      name = "auto-connect-ports";
      script = ./auto-connect-ports.lua;
      scriptCfg = cfg.autoConnectPorts;

      genFunctionCall = rule: ''
        auto_connect_ports {
          output_subject = "${rule.output.subject}",
          output_left_port = "${rule.output.leftPort}",
          output_right_port = "${rule.output.rightPort}",

          input_subject = "${rule.input.subject}",
          input_left_port = "${rule.input.leftPort}",
          input_right_port = "${rule.input.rightPort}"
        }
      '';
    }))
  ];
}
