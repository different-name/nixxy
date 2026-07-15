{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "vscodium" ] {
  home-manager = { pkgs, ... }: {
    programs.vscodium = {
      enable = true;

      profiles.default = {
        extensions =
          let
            extensionsPkgs = pkgs.extend inputs.nix-vscode-extensions.overlays.default;
            inherit (extensionsPkgs.nix-vscode-extensions) vscode-marketplace;
          in
          with vscode-marketplace;
          [
            # keep-sorted start
            anthropic.claude-code
            blueglassblock.better-json5
            dbaeumer.vscode-eslint
            editorconfig.editorconfig
            graphql.vscode-graphql
            graphql.vscode-graphql-syntax
            kdl-org.kdl
            ms-pyright.pyright
            ms-python.black-formatter
            ms-python.pylint
            ms-python.python
            prettiercode.code-prettier
            slevesque.shader
            stevensona.shader-toy
            tamasfe.even-better-toml
            thenuprojectcontributors.vscode-nushell-lang
            # keep-sorted end
          ];

        userSettings = {
          # keep-sorted start block=yes
          "claudeCode.claudeProcessWrapper" = "${pkgs.claude-code}/bin/claude";
          "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;
          "files.associations" = {
            "*.poiTemplateCollection" = "hlsl";
          };
          "files.enableTrash" = false;
          "git.confirmSync" = false;
          "git.detectSubmodules" = false;
          "git.repositoryScanMaxDepth" = 3;
          "html.format.templating" = true;
          "scm.alwaysShowRepositories" = true;
          "shader-toy.forceAspectRatio" = [
            1
            1
          ];
          "shader-toy.reloadOnEditText" = false;
          "window.titleBarStyle" = "custom";
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.secondarySideBar.defaultVisibility" = "hidden";
          "workbench.startupEditor" = "none";
          # keep-sorted end
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      # keep-sorted start
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";
      # keep-sorted end
    };

    wayland.windowManager.hyprland.settings.env = [
      "EDITOR,codium --wait"
    ];

    home.perpetual.default.dirs = [
      "$configHome/VSCodium"
      "$stateHome/VSCodium"
    ];
  };
}
