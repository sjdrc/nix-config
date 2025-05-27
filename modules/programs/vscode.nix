{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          asvetliakov.vscode-neovim
          vadimcn.vscode-lldb
          mhutchie.git-graph
        ];
        userSettings = {
          "extensions.experimental.affinity" = {
            "asvetliakov.vscode-neovim" = 1;
          };
          "git.confirmSync" = true;
          "cmake.showConfigureWithDebuggerNotification" = false;
          "C_Cpp.intelliSenseEngine" = "disabled";
        };
      };
    };
  };
}
