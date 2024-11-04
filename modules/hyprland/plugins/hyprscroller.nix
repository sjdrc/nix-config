{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland.layout = lib.mkOption {
      type = with lib.types; nullOr (enum ["hyprscroller"]);
    };
  };

  config = lib.mkIf (config.hyprland.layout == "hyprscroller") {
    home-manager.users.sebastien = {
      wayland.windowManager.hyprland = {
        plugins = [pkgs.hyprlandPlugins.hyprscroller];
        settings = {
          plugin.scroller = {
            column_default_width = "onehalf";
            focus_wrap = false;
          };
          bind = [
            # Move focus with m1 + arrow keys
            "$m1, left,           scroller:movefocus, l"
            "$m1, right,          scroller:movefocus, r"
            "$m1, up,             scroller:movefocus, u"
            "$m1, down,           scroller:movefocus, d"
            "$m1, home,           scroller:movefocus, begin"
            "$m1, end,            scroller:movefocus, end"

            # Movement
            "$m2, left,           scroller:movewindow, l"
            "$m2, right,          scroller:movewindow, r"
            "$m2, up,             scroller:movewindow, u"
            "$m2, down,           scroller:movewindow, d"
            "$m2, home,           scroller:movewindow, begin"
            "$m2, end,            scroller:movewindow, end"

            # Modes
            "$m1, bracketleft,    scroller:setmode, row"
            "$m1, bracketright,   scroller:setmode, col"

            # Sizing keys
            "$m1, equal,          scroller:cyclesize, next"
            "$m1, minus,          scroller:cyclesize, prev"
            "$m3, left,           scroller:setmode, row"
            "$m3, left,           scroller:fitsize, tobeg"
            "$m3, right,          scroller:setmode, row"
            "$m3, right,          scroller:fitsize, toend"
            "$m3, up,             scroller:setmode, col"
            "$m3, up,             scroller:fitsize, tobeg"
            "$m3, down,           scroller:setmode, col"
            "$m3, down,           scroller:fitsize, toend"
          ];
        };
        extraConfig = ''
          # Fit size submap
          # will switch to a submap called fitsize
          bind = $m1, W, submap, fitsize
          # will start a submap called "fitsize"
          submap = fitsize
          # sets binds for fitting columns/windows in the screen
          bind = , W, scroller:fitsize, visible
          bind = , W, submap, reset
          bind = , right, scroller:fitsize, toend
          bind = , right, submap, reset
          bind = , left, scroller:fitsize, tobeg
          bind = , left, submap, reset
          bind = , up, scroller:fitsize, active
          bind = , up, submap, reset
          bind = , down, scroller:fitsize, all
          bind = , down, submap, reset
          # use reset to go back to the global submap
          bind = , escape, submap, reset
          # will reset the submap, meaning end the current one and return to the global one
          submap = reset

          # overview keys
          # bind key to toggle overview (normal)
          bind = $m1, tab, scroller:toggleoverview
          # overview submap
          # will switch to a submap called overview
          bind = $m1, tab, submap, overview
          # will start a submap called "overview"
          submap = overview
          bind = , right, scroller:movefocus, right
          bind = , left, scroller:movefocus, left
          bind = , up, scroller:movefocus, up
          bind = , down, scroller:movefocus, down
          # use reset to go back to the global submap
          bind = , escape, scroller:toggleoverview,
          bind = , escape, submap, reset
          bind = , return, scroller:toggleoverview,
          bind = , return, submap, reset
          bind = $m1, tab, scroller:toggleoverview,
          bind = $m1, tab, submap, reset
          # will reset the submap, meaning end the current one and return to the global one
          submap = reset

        '';
      };
    };
  };
}
