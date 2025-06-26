{pkgs, ...}: {
  fonts.packages = with pkgs.nerd-fonts; [fira-code];
  users.defaultUserShell = pkgs.bash;
  environment.systemPackages = with pkgs; [
    systemctl-tui
    bluetuith
    lnav
  ];
  home-manager.users.sebastien.programs = {
    fzf.enable = true;
    atuin.enable = true;
    tmux.enable = true;
    htop.enable = true;
    starship.enable = true;
    eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
      git = true;
      icons = "auto";
    };
  };
  home-manager.users.sebastien.home.packages = with pkgs; [
    wget
    systemctl-tui
    bluetuith
    lnav
    # Docker tools
    lazydocker
    dive
  ];
}
