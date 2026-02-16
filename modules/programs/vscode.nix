{
  homeModule = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.vscode.enable = lib.mkEnableOption "Visual Studio Code";

    config = lib.mkIf config.custom.programs.vscode.enable {
      home.packages = with pkgs; [
        nixd
        alejandra
      ];

      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            asvetliakov.vscode-neovim
            vadimcn.vscode-lldb
            mhutchie.git-graph
            jnoortheen.nix-ide
            mkhl.direnv
            anthropic.claude-code
          ];
          userSettings = {
            "extensions.experimental.affinity" = {
              "asvetliakov.vscode-neovim" = 1;
            };
            "git.confirmSync" = true;
            "cmake.showConfigureWithDebuggerNotification" = false;
            "C_Cpp.intelliSenseEngine" = "disabled";

            # Nuclear option: Disable all AI/Copilot features
            "chat.disableAIFeatures" = true;
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
  };
}
