{...}: {
  flake.nixosModules.code-server = {
    config,
    lib,
    pkgs,
    ...
  }: let
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

    extensionDir = pkgs.buildEnv {
      name = "code-server-extensions";
      paths = extensions;
      pathsToLink = ["/share/vscode/extensions"];
    };
  in {
    options.custom.programs.code-server.enable =
      lib.mkEnableOption "code-server (VS Code in the browser)";

    config = lib.mkIf config.custom.programs.code-server.enable {
      services.code-server = {
        enable = true;
        user = config.custom.profiles.user.name;
        group = "users";
        extraGroups = ["docker"];
        host = "0.0.0.0";
        port = 4444;
        auth = "none";
        disableTelemetry = true;
        disableUpdateCheck = true;
        extensionsDir = "${extensionDir}/share/vscode/extensions";

        extraPackages = with pkgs; [
          nixd
          alejandra
          git
        ];

        extraArguments = [
          "--disable-getting-started-override"
        ];
      };
    };
  };

  flake.homeModules.code-server = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.code-server.enable =
      lib.mkEnableOption "code-server (VS Code in the browser)";

    config = lib.mkIf config.custom.programs.code-server.enable {
      home.packages = with pkgs; [
        nixd
        alejandra
      ];

      # Write VS Code settings for code-server
      home.file.".local/share/code-server/User/settings.json".text = builtins.toJSON {
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "git.confirmSync" = true;
        "cmake.showConfigureWithDebuggerNotification" = false;
        "C_Cpp.intelliSenseEngine" = "disabled";

        # Disable all AI/Copilot features
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
}
