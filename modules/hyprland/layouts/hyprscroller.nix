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
            "SUPER       , left,           scroller:movefocus, l"
            "SUPER       , right,          scroller:movefocus, r"
            "SUPER       , up,             scroller:movefocus, u"
            "SUPER       , down,           scroller:movefocus, d"
            "SUPER       , home,           scroller:movefocus, begin"
            "SUPER       , end,            scroller:movefocus, end"

            # Movement
            "SUPER SHIFT , left,           scroller:movewindow, l"
            "SUPER SHIFT , right,          scroller:movewindow, r"
            "SUPER SHIFT , up,             scroller:movewindow, u"
            "SUPER SHIFT , down,           scroller:movewindow, d"
            "SUPER SHIFT , home,           scroller:movewindow, begin"
            "SUPER SHIFT , end,            scroller:movewindow, end"

            # Modes
            "SUPER       , bracketleft,    scroller:setmode, row"
            "SUPER       , bracketright,   scroller:setmode, col"

            # Sizing keys
            "SUPER       , equal,          scroller:cyclesize, next"
            "SUPER       , minus,          scroller:cyclesize, prev"
            "SUPER CTRL   , left,           scroller:setmode, row"
            "SUPER CTRL   , left,           scroller:fitsize, tobeg"
            "SUPER CTRL   , right,          scroller:setmode, row"
            "SUPER CTRL   , right,          scroller:fitsize, toend"
            "SUPER CTRL   , up,             scroller:setmode, col"
            "SUPER CTRL   , up,             scroller:fitsize, tobeg"
            "SUPER CTRL   , down,           scroller:setmode, col"
            "SUPER CTRL   , down,           scroller:fitsize, toend"
          ];
        };
        extraConfig = ''
          # Fit size submap
          # will switch to a submap called fitsize
          bind = SUPER       , W, submap, fitsize
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
          bind = SUPER       , tab, scroller:toggleoverview
          # overview submap
          # will switch to a submap called overview
          bind = SUPER       , tab, submap, overview
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
          bind = SUPER       , tab, scroller:toggleoverview,
          bind = SUPER       , tab, submap, reset
          # will reset the submap, meaning end the current one and return to the global one
          submap = reset

        '';
      };
    };
  };
}
