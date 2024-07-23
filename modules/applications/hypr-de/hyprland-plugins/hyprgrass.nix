{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [ hyprlandPlugins.hyprgrass ];
      settings = {
        gestures = {
          workspace_swipe = true;
          workspace_swipe_cancel_ratio = 0.15;
        };

        plugin = {
          touch_gestures = {
            # The default sensitivity is probably too low on tablet screens,
            # I recommend turning it up to 4.0
            sensitivity = 1.0;

            # must be >= 3
            workspace_swipe_fingers = 3;

            # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
            # and can be used at the same time
            # possible values: l, r, u, or d
            # to disable it set it to anything else
            workspace_swipe_edge = "d";

            # in milliseconds
            long_press_delay = 400;

            experimental = {
              # send proper cancel events to windows instead of hacky touch_up events,
              # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
              send_cancel = 0;
            };

            hyprgrass-bind = [
              # swipe left from right edge
              ", edge:r:l, workspace, +1"

              # swipe up from bottom edge
              ", edge:d:u, exec, firefox"

              # swipe down from left edge
              ", edge:l:d, exec, pactl set-sink-volume @DEFAULT_SINK@ -4%"

              # swipe down with 4 fingers
              # NOTE: swipe events only trigger for finger count of >= 3
              ", swipe:4:d, killactive"

              # swipe diagonally left and down with 3 fingers
              # l (or r) must come before d and u
              ", swipe:3:ld, exec, foot"

              # tap with 3 fingers
              # NOTE: tap events only trigger for finger count of >= 3
              ", tap:3, exec, foot"
            ];
            hyprgrass-bindm = [
              # longpress can trigger mouse binds:
              ", longpress:2, movewindow"
              ", longpress:3, resizewindow"
            ];
          };
        };
      };
    };
  };
}
