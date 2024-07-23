{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [ hyprlandPlugins.hy3 ];
      settings = {
        general = {
          layout = "hy3";
        };
        bind = [
          "$m1, W,              hy3:killactive,"
          "$m1, H,              hy3:makegroup, h"
          "$m1, V,              hy3:makegroup, v"
          "$m1, backspace,      hy3:makegroup, opposite"
          "$m1, left,           hy3:movefocus, l"
          "$m1, right,          hy3:movefocus, r"
          "$m1, up,             hy3:movefocus, u"
          "$m1, down,           hy3:movefocus, d"
          "$m2, 1,              hy3:movetoworkspace, 1,"
          "$m2, 2,              hy3:movetoworkspace, 2,"
          "$m2, 3,              hy3:movetoworkspace, 3,"
          "$m2, 4,              hy3:movetoworkspace, 4,"
          "$m2, 5,              hy3:movetoworkspace, 5,"
          "$m2, 6,              hy3:movetoworkspace, 6,"
          "$m2, 7,              hy3:movetoworkspace, 7,"
          "$m2, 8,              hy3:movetoworkspace, 8,"
          "$m2, 9,              hy3:movetoworkspace, 9,"
          "$m2, 0,              hy3:movetoworkspace, 10,"
        ];
        plugin = {
          hy3 = {
            # disable gaps when only one window is onscreen
            # 0 - always show gaps
            # 1 - hide gaps with a single window onscreen
            # 2 - 1 but also show the window border
            #no_gaps_when_only = <int> # default: 0

            # policy controlling what happens when a node is removed from a group,
            # leaving only a group
            # 0 = remove the nested group
            # 1 = keep the nested group
            # 2 = keep the nested group only if its parent is a tab group
            #node_collapse_policy = <int> # default: 2

            # offset from group split direction when only one window is in a group
            #group_inset = <int> # default: 10

            # if a tab group will automatically be created for the first window spawned in a workspace
            #tab_first_window = <bool>

            # tab group settings
            #tabs = {
            #  # height of the tab bar
            #  height = <int> # default: 15

            #  # padding between the tab bar and its focused node
            #  padding = <int> # default: 5

            #  # the tab bar should animate in/out from the top instead of below the window
            #  from_top = <bool> # default: false

            #  # rounding of tab bar corners
            #  rounding = <int> # default: 3

            #  # render the window title on the bar
            #  render_text = <bool> # default: true

            #  # center the window title
            #  text_center = <bool> # default: false

            #  # font to render the window title with
            #  text_font = <string> # default: Sans

            #  # height of the window title
            #  text_height = <int> # default: 8

            #  # left padding of the window title
            #  text_padding = <int> # default: 3

            #  # active tab bar segment color
            #  col.active = <color> # default: 0xff32b4ff

            #  # urgent tab bar segment color
            #  col.urgent = <color> # default: 0xffff4f4f

            #  # inactive tab bar segment color
            #  col.inactive = <color> # default: 0x80808080

            #  # active tab bar text color
            #  col.text.active = <color> # default: 0xff000000

            #  # urgent tab bar text color
            #  col.text.urgent = <color> # default: 0xff000000

            #  # inactive tab bar text color
            #  col.text.inactive = <color> # default: 0xff000000
            #}

            # autotiling settings
            #autotile = {
            #  # enable autotile
            #  enable = <bool> # default: false

            #  # make autotile-created groups ephemeral
            #  ephemeral_groups = <bool> # default: true

            #  # if a window would be squished smaller than this width, a vertical split will be created
            #  # -1 = never automatically split vertically
            #  # 0 = always automatically split vertically
            #  # <number> = pixel height to split at
            #  trigger_width = <int> # default: 0

            #  # if a window would be squished smaller than this height, a horizontal split will be created
            #  # -1 = never automatically split horizontally
            #  # 0 = always automatically split horizontally
            #  # <number> = pixel height to split at
            #  trigger_height = <int> # default: 0

            #  # a space or comma separated list of workspace ids where autotile should be enabled
            #  # it's possible to create an exception rule by prefixing the definition with "not:"
            #  # workspaces = 1,2 # autotiling will only be enabled on workspaces 1 and 2
            #  # workspaces = not:1,2 # autotiling will be enabled on all workspaces except 1 and 2
            #  workspaces = <string> # default: all
            #}
          };
        };
      };
    };
  };
}
