{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;
  home-manager.users.sebastien = {
    programs.fzf.enable = true;
    programs.atuin.enable = true;
    programs.eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
    home.packages = with pkgs; [
      tmux
      wget
      systemctl-tui
      bluetuith
      lnav
      htop
      # Docker tools
      lazydocker
      dive
    ];
  };
}
