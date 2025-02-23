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
          general = {
            layout = "scroller";
          };
          plugin.scroller = {
            column_default_width = "onethird";
            column_widths = "onesixth onethird onehalf twothirds";
            window_heights = "onethird onehalf twothirds one";
            cyclesize_wrap = false;
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

            # Sizing keys
            "SUPER CTRL   , left,           scroller:cyclewidth, prev"
            "SUPER CTRL   , right,          scroller:cyclewidth, next"
            "SUPER CTRL   , up,             scroller:cycleheight, prev"
            "SUPER CTRL   , down,           scroller:cycleheight, next"
          ];
        };
        extraConfig = ''
          # overview keys
          bind = SUPER       , tab, scroller:toggleoverview
          bind = SUPER       , tab, submap, overview
          submap = overview

          bind = , right,     scroller:movefocus, right
          bind = , left,      scroller:movefocus, left
          bind = , up,        scroller:movefocus, up
          bind = , down,      scroller:movefocus, down
          bind = , escape,    scroller:toggleoverview,
          bind = , escape,    submap, reset
          bind = , return,    scroller:toggleoverview,
          bind = , return,    submap, reset
          bind = SUPER , tab, scroller:toggleoverview,
          bind = SUPER , tab, submap, reset
          # will reset the submap, meaning end the current one and return to the global one
          submap = reset

        '';
      };
    };
  };
}
