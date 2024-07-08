{ ... }:
{
  home.packages = with pkgs; [
    openlens
    slack
    google-chrome
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}