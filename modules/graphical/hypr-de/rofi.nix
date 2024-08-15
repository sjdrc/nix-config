{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    wayland.windowManager.hyprland.settings."$launcher" = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
  };
}
