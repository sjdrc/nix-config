{ config, pkgs, ... }:
{
  imports = [
    ../applications/bash.nix
    ../applications/nvim.nix
  ];

  home-manager.users.${config.user} = {
    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    programs.eza = {
      enable = true;
      enableBashIntegration = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = true;
    };
    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
    };
    home.packages = with pkgs; [
      tmux
      wget
      systemctl-tui
      bluetuith
      lnav
      # Docker tools
      lazydocker
      dive
    ];
  };
}
