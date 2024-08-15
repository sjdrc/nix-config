{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.hypr-workspace-layouts ];
      settings = {
        plugin.wslayout = {
          defaultLayout = "hy3";
        };
        general = {
          layout = "hy3";
        };
      };
    };
  };
}
