{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.vscode = {
      enable = true;
      package = pkgs.openvscode-server;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        mhutchie.git-graph
      ];
      userSettings = {
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "git.confirmSync" = true;
      };
    };
  };

  services.openvscode-server = {
    enable = true;
    user = "sebastien";
    group = "users";
    telemetryLevel = "off";
    withoutConnectionToken = true;
  };
}
