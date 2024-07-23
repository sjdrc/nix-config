{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [ hyprlandPlugins.hyprscroller ];
      settings = {
        general = {
          layout = "scroller";
        };
        plugin = {
          scroller = {
            column_default_width = "onehalf";
            focus_wrap = false;
          };
        };
        bind = [
          # Move focus with m1 + arrow keys
          "$m1, left, scroller:movefocus, l"
          "$m1, right, scroller:movefocus, r"
          "$m1, up, scroller:movefocus, u"
          "$m1, down, scroller:movefocus, d"
          "$m1, home, scroller:movefocus, begin"
          "$m1, end, scroller:movefocus, end"

          # Movement
          "$m2, left, scroller:movewindow, l"
          "$m2, right, scroller:movewindow, r"
          "$m2, up, scroller:movewindow, u"
          "$m2, down, scroller:movewindow, d"
          "$m2, home, scroller:movewindow, begin"
          "$m2, end, scroller:movewindow, end"

          # Modes
          "$m1, bracketleft, scroller:setmode, row"
          "$m1, bracketright, scroller:setmode, col"

          # Sizing keys
          "$m1, equal, scroller:cyclesize, next"
          "$m1, minus, scroller:cyclesize, prev"
        ];
        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$m1, mouse:272, movewindow"
          "$m1, mouse:273, movewindow"
        ];
      };
      extraConfig = ''
        # Center submap
        # will switch to a submap called center
        bind = $m1, C, submap, center
        # will start a submap called "center"
        submap = center
        # sets repeatable binds for resizing the active window
        bind = , C, scroller:alignwindow, c
        bind = , C, submap, reset
        bind = , right, scroller:alignwindow, r
        bind = , right, submap, reset
        bind = , left, scroller:alignwindow, l
        bind = , left, submap, reset
        bind = , up, scroller:alignwindow, u
        bind = , up, submap, reset
        bind = , down, scroller:alignwindow, d
        bind = , down, submap, reset
        # use reset to go back to the global submap
        bind = , escape, submap, reset
        # will reset the submap, meaning end the current one and return to the global one
        submap = reset

        # Resize submap
        # will switch to a submap called resize
        bind = $m1 SHIFT, R, submap, resize
        # will start a submap called "resize"
        submap = resize
        # sets repeatable binds for resizing the active window
        binde = , right, resizeactive, 100 0
        binde = , left, resizeactive, -100 0
        binde = , up, resizeactive, 0 -100
        binde = , down, resizeactive, 0 100
        # use reset to go back to the global submap
        bind = , escape, submap, reset
        # will reset the submap, meaning end the current one and return to the global one
        submap = reset

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

        # Marks
        bind = $m1, M, submap, marksadd
        submap = marksadd
        bind = , a, scroller:marksadd, a
        bind = , a, submap, reset
        bind = , b, scroller:marksadd, b
        bind = , b, submap, reset
        bind = , c, scroller:marksadd, c
        bind = , c, submap, reset
        bind = , escape, submap, reset
        submap = reset

        bind = $m1 SHIFT, M, submap, marksdelete
        submap = marksdelete
        bind = , a, scroller:marksdelete, a
        bind = , a, submap, reset
        bind = , b, scroller:marksdelete, b
        bind = , b, submap, reset
        bind = , c, scroller:marksdelete, c
        bind = , c, submap, reset
        bind = , escape, submap, reset
        submap = reset

        bind = $m1, apostrophe, submap, marksvisit
        submap = marksvisit
        bind = , a, scroller:marksvisit, a
        bind = , a, submap, reset
        bind = , b, scroller:marksvisit, b
        bind = , b, submap, reset
        bind = , c, scroller:marksvisit, c
        bind = , c, submap, reset
        bind = , escape, submap, reset
        submap = reset

        bind = $m1 CTRL, M, scroller:marksreset
      '';
    };
  };
}
