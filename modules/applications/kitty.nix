{ pkgs, ... }:
{
  hmConfig = {
    programs.kitty = {
      enable = true;
      settings = {
        open_url_with = "xdg-open";
        enable_audio_bell = false;
      };
    };
    wayland.windowManager.hyprland.settings."$terminal" = "${pkgs.kitty}/bin/kitty";
    programs.rofi.terminal = "${pkgs.kitty}/bin/kitty";
  };
}
