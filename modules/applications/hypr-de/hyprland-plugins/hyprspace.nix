{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [ hyprlandPlugins.hyprspace ];
      settings = {
        plugin = {
          overview = {
            #panelColor
            #panelBorderColor
            #workspaceActiveBackground
            #workspaceInactiveBackground
            #workspaceActiveBorder
            #workspaceInactiveBorder
            #dragAlpha #overrides the alpha of window when dragged in overview (0 - 1, 0 = transparent, 1 = opaque)
            #panelHeight
            #panelBorderWidth
            #onBottom whether if panel should be on bottom instead of top
            #workspaceMargin spacing of workspaces with eachother and the edge of the panel
            #reservedArea padding on top of the panel, for Macbook camera notch
            #workspaceBorderSize
            #centerAligned whether if workspaces should be aligned at the center (KDE / macOS style) or at the left (Windows style)
            #hideBackgroundLayers do not draw background and bottom layers in overview
            #hideTopLayers do not draw top layers in overview
            #hideOverlayLayers do not draw overlay layers in overview
            #hideRealLayers whether to hide layers in actual workspace
            #drawActiveWorkspace draw the active workspace in overview as-is
            #overrideGaps whether if overview should override the layout gaps in the current workspace using the following values
            #gapsIn
            #gapsOut
            #affectStrut whether the panel should push window aside, disabling this option also disables overrideGaps
            #overrideAnimSpeed to override the animation speed
            #autoDrag mouse click always drags window when overview is open
            #autoScroll mouse scroll on active workspace area always switch workspace
            #exitOnClick mouse click without dragging exits overview
            #switchOnDrop switch to the workspace when a window is droppped into it
            #exitOnSwitch overview exits when overview is switched by clicking on workspace view or by switchOnDrop
            #showNewWorkspace add a new empty workspace at the end of workspaces view
            #showEmptyWorkspace show empty workspaces that are inbetween non-empty workspaces
            #showSpecialWorkspace defaults to false
            #disableGestures
            #reverseSwipe reverses the direction of swipe gesture, for macOS peeps?
          };
        };

        #gestures = {
        #  workspace_swipe_fingers =
        #  workspace_swipe_cancel_ratio =
        #  workspace_swipe_min_speed_to_force =
        #};

        bind = [ "$m2, grave,          overview:toggle," ];
      };
    };
  };
}
