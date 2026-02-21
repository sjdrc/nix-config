flakeArgs @ {...}: {
  flake.homeModules.vscode = {pkgs, config, ...}: {
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
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings" = {
            "nixd" = {
              "nixpkgs" = {
                "expr" = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs {}";
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.dione.options";
                };
                "home-manager" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.dione.config.home-manager.users.sebastien.options";
                };
              };
            };
          };
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

  flake.nixosModules.vscode = {config, lib, ...}: {
    options.custom.vscode.enable = lib.mkEnableOption "Visual Studio Code";
    config = lib.mkIf config.custom.vscode.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.vscode];
    };
  };
}
