{ inputs, ... }: {
  dyad = {
    host = {
      machineId = "f973333893a548168337a2a8c258685b";
      stateVersion = "26.11";
    };

    users.diffy.enable = true;

    profiles.graphical.enable = true;

    services.backup.enable = true;

    hardware = {
      battery.enable = true;
      bluetooth.enable = true;
    };

    system = {
      btrfs.enable = true;
      keep.enable = true;
      secure-boot.enable = true;
    };

    nix.sodium-builder.enable = true;

    services = {
      printing.enable = true;
    };
  };

  nixos = { lib, pkgs, ... }: {
    fileSystems."/scratch".neededForBoot = true;

    imports = [
      # keep-sorted start
      ./_disko.nix
      inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      # keep-sorted end
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-intel" ];
    hardware.enableRedistributableFirmware = true;
    # framework-laptop-kmod ships no .ko.cer, which the modules tree now requires
    hardware.framework.enableKmod = false;

    # the ec ignores cros_charge_control, only its own charge limit command works
    systemd.services.charge-limit = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe' pkgs.framework-tool "framework_tool"} --charge-limit 80";
      };
    };

    keep.safe.dirs = [ "/var/lib/fprint" ];

    # laptop joins untrusted networks, ssh only over the tailnet
    services.openssh.openFirewall = false;
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  };

  home-manager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.hyprland)
        mod
        lua
        bind
        exec
        ;

      inherit (inputs) hyprgrass;
      hexecute = inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [ ./hexecute/palette.patch ];
        postPatch = old.postPatch or "" + ''
          substituteInPlace internal/shaders/*.frag.glsl \
            --replace-quiet @greenHue@ ${toString (config.dyad.palette.green.hsl.h / 360)} \
            --replace-quiet @mauveHue@ ${toString (config.dyad.palette.mauve.hsl.h / 360)}
        '';
      });
      hyprlandVersion = pkgs.hyprland.version;

      touchBind = fingers: action: {
        inherit mod;
        pattern = {
          kind = "longpress";
          inherit fingers;
        };
        action = lua action;
        mouse = true;
      };

      osdBattery = pkgs.writeShellApplication {
        name = "osd-battery";
        runtimeInputs = [ pkgs.swayosd ];
        text = ''
          bat=/sys/class/power_supply/BAT1
          capacity=$(<"$bat/capacity")
          status=$(<"$bat/status")

          level=$((capacity / 10 * 10))
          case "$status" in
          Full) icon=battery-level-100-charged-symbolic ;;
          Charging) icon=battery-level-$level-charging-symbolic ;;
          *) icon=battery-level-$level-symbolic ;;
          esac
          # papirus has no 100-charging icon
          [ "$icon" = battery-level-100-charging-symbolic ] && icon=battery-level-100-charged-symbolic

          progress=1
          [ "$capacity" -lt 100 ] && progress=$(printf '0.%02d' "$capacity")

          swayosd-client --custom-icon "$icon" \
            --custom-progress "$progress" --custom-progress-text "$capacity%"
        '';
      };
    in
    {
      assertions = lib.singleton {
        assertion = lib.hasInfix "# v${hyprlandVersion}" (builtins.readFile "${hyprgrass}/hyprpm.toml");
        message = "hyprgrass has no pin for hyprland ${hyprlandVersion}, point its flake input at the matching commit in hyprpm.toml";
      };

      home.packages = [
        hexecute
        osdBattery
      ];

      xdg.configFile = {
        "hexecute/gestures.json".source = ./hexecute/gestures.json;
        "hexecute/settings.json".text = builtins.toJSON { overlay_alpha = 0.75; };
      };

      wayland.windowManager.hyprland = {
        plugins = lib.singleton (
          pkgs.callPackage "${hyprgrass}/nix/default.nix" {
            # nixpkgs wf-touch is newer than hyprgrass builds against
            wf-touch = pkgs.callPackage "${hyprgrass}/nix/wf-touch.nix" { };
            tag = lib.removePrefix "v" (lib.trim (builtins.readFile "${hyprgrass}/VERSION"));
            commit = hyprgrass.shortRev;
          }
        );

        settings = {
          bind = [ (bind "${mod} + B" (exec (lib.getExe osdBattery))) ];

          # touch input never reaches mouse binds
          "plugin.hyprgrass.bind" = [
            (touchBind 1 "hl.dsp.window.drag()")
            (touchBind 2 "hl.dsp.window.resize()")
            {
              pattern = {
                kind = "tap";
                fingers = 3;
              };
              # wrapper renames the process, so match the argv0 path instead of the name
              action = lua (exec "pkill -f '^${hexecute}/bin/hexecute' || ${hexecute}/bin/hexecute");
            }
          ];
        };
      };
    };
}
