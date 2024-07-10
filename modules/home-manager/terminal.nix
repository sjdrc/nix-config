{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      open_url_with = "xdg-open";
      enable_audio_bell = false;
    };
  };
  
  home.packages = with pkgs; [
    tmux
    wget
    systemctl-tui
    # Docker tools
    lazydocker
    dive
  ];
}