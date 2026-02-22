{...}: {
  flake.homeModules.vscode = {osConfig, lib, pkgs, config, ...}: lib.mkIf osConfig.custom.vscode.enable {
    home.packages = with pkgs; [
      nixd
      alejandra
    ];

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions =
          (with pkgs.vscode-marketplace; [
            asvetliakov.vscode-neovim
            mhutchie.git-graph
            jnoortheen.nix-ide
            mkhl.direnv
            anthropic.claude-code
            es6kr.claude-sessions
          ])
          ++ (with pkgs.vscode-marketplace-universal; [
            vadimcn.vscode-lldb
          ]);
        userSettings = {
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
          "[nix]" = {
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = false;
            "editor.formatOnType" = true;
          };
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.formatterPath" = "alejandra";
          "nix.serverSettings" = {
            "nixd" = {
              "nixpkgs" = {
                "expr" = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs {}";
              };
              "formatting" = {
                "command" = ["alejandra"];
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.dione.options";
                };
                "home-manager" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.dione.options.home-manager.users.type.getSubOptions []";
                };
              };
            };
          };
          "terminal.integrated.fontFamily" = "'DejaVu Sans Mono', 'FiraCode Nerd Font Mono'";
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;
          "cmake.showConfigureWithDebuggerNotification" = false;
          "C_Cpp.intelliSenseEngine" = "disabled";

          # Nuclear option: Disable all AI/Copilot features
          "chat.disableAIFeatures" = true;
          "update.mode" = "none";
          "extensions.ignoreRecommendations" = true;
          "workbench.tips.enabled" = false;
          "workbench.enableExperiments" = false;
          "github.copilot.enable" = false;
          "github.copilot.inlineSuggest.enable" = false;

          # Use system claude-code binary (has MCP servers configured)
          "claudeCode.claudeProcessWrapper" = "${config.programs.claude-code.finalPackage}/bin/claude";
        };
      };
    };
  };

  flake.nixosModules.vscode = {lib, ...}: {
    options.custom.vscode.enable = lib.mkEnableOption "Visual Studio Code";
  };
}
