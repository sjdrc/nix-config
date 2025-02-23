{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.vscode = {
      enable = true;
      package = pkgs.openvscode-server;
      profiles.default = {
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
  };

  services.openvscode-server = {
    enable = true;
    port = 3000;
    host = "0.0.0.0";
    user = "sebastien";
    group = "users";
    telemetryLevel = "off";
    withoutConnectionToken = true;
  };

  services.code-server = {
    enable = true;
    disableTelemetry = true;
    disableUpdateCheck = true;
    auth = "none";
    host = "0.0.0.0";
    user = "sebastien";
    group = "users";
  };
}
