{ pkgs, ... }:
{
  hmConfig = {
    home.packages = with pkgs; [
      bambu-studio
      orca-slicer
      signal-desktop
      wl-clipboard
    ];

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
      ];
      userSettings = {
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;        
        };
      };
    };
  };

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
