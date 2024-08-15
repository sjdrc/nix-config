{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [ hyprlandPlugins.hy3 ];
      settings = {
        general = {
          layout = "hy3";
        };
        plugin.hy3 = { };
        bind = [
          "$m2, Q,              hy3:killactive,"
          "$m1, backspace,      hy3:makegroup, opposite, ephemeral"
          "$m1, left,           hy3:movefocus, l"
          "$m1, right,          hy3:movefocus, r"
          "$m1, up,             hy3:movefocus, u"
          "$m1, down,           hy3:movefocus, d"
          "$m2, left,           hy3:movewindow, l"
          "$m2, right,          hy3:movewindow, r"
          "$m2, up,             hy3:movewindow, u"
          "$m2, down,           hy3:movewindow, d"
          #"$m2, 1,              hy3:movetoworkspace, 1,"
          #"$m2, 2,              hy3:movetoworkspace, 2,"
          #"$m2, 0,              hy3:movetoworkspace, 10,"
        ];
      };
    };
  };
}
