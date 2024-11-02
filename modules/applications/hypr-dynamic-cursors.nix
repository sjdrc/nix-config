{pkgs, ...}: {
  home-manager.users.sebastien = {
    wayland.windowManager.hyprland = {
      plugins = [pkgs.hyprlandPlugins.hypr-dynamic-cursors];
      settings = {
        plugin.dynamic-cursors = {
          enabled = true;
          mode = "tilt";
          tilt = {
            limit = 500;
            function = "quadratic";
          };
          shake.enabled = false;
        };
      };
    };
  };
}
