{pkgs, ...}: {
  home-manager.users.sebastien = {
    home.packages = with pkgs; [
      orca-slicer
      signal-desktop
    ];

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

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
