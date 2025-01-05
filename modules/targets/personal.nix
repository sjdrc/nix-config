{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
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

  environment.systemPackages = with pkgs; [
    zen-browser
  ];

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
