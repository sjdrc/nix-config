{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = [ pkgs.hyprlandPlugins.hypr-dynamic-cursors ];
      settings = {
        plugin.dynamic-cursors = {
          enabled = true;
          mode = "tilt";
          tilt = {
            limit = 5000;
            function = "quadratic";
          };
          shake.enabled = false;
        };
      };
    };
  };
}
