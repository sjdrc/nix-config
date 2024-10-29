{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
  };

  environment.sessionVariables = {
    # Force wayland for electron applications
    NIXOS_OZONE_WL = "1";
  };

  hmConfig = {
    home.packages = with pkgs; [ polkit_gnome ];

    services.kanshi.systemdTarget = "hyprland-session.target";

    # Window Manager
    wayland.windowManager.hyprland = {
      enable = true;

      systemd.variables = [ "--all" ];

      settings = {
        # Default applications
        "$fileManager" = "dolphin";

        debug.disable_logs = false;

        exec-once = [ "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &" ];

        general = {
          border_size = 2;
          gaps_in = 5;
          gaps_out = 20;
          resize_on_border = true;
          extend_border_grab_area = 20;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
          };
        };

        animations = {
          bezier = "snap, 0.05, 0.95, 0.1, 1";
          animation = [
            "windows, 1, 7, snap"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          enable_swallow = true;
          swallow_regex = [ "^(kitty)$" ];
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        monitor = [ "FALLBACK, 1920x1080@60, auto, 1" ];

        # Screen sharing settings
        # bitdepth needs to be set to 10 to get screensharing to work for some reason
        # Visit https://mozilla.github.io/webrtc-landing/gum_test.html to test
        #monitor = [ ", preferred, auto, 1, bitdepth, 10" ];
        windowrule = [ "float,title:^(MainPicker)$" ];

        workspace = [
          "1,               defaultName:main"
          "2,               defaultName:work"
          "10,              defaultName:comms"
        ];

        # Modifier key combos
        "$m1" = "SUPER";
        "$m2" = "SUPER SHIFT";
        "$m3" = "SUPER CTRL";
        "$m4" = "SUPER ALT";

        bind = [
          # Application shortcuts
          "$m1, Space,          exec, $launcher"
          "$m1, Return,         exec, $terminal"
          "$m2, N,              exec, $fileManager"

          # Window controls
          "$m1, F,              fullscreen, 1"
          "$m2, Q,              killactive,"
          "$m2, F,              togglefloating, active"
          "$m2, P,              pin, active"

          # Workspace controls
          "$m1, 1,              workspace, 1"
          "$m1, 2,              workspace, 2"
          "$m1, 0,              workspace, 10"
          "$m2, 1,              movetoworkspacesilent, 1"
          "$m2, 2,              movetoworkspacesilent, 2"
          "$m2, 0,              movetoworkspacesilent, 10"

          # Scrach workspace
          "$m1, S,              togglespecialworkspace"
          "$m2, S,              movetoworkspacesilent, special"
          "$m3, S,              movetoworkspacesilent, e+0"
        ];
        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$m1, mouse:272, movewindow"
          "$m1, mouse:273, movewindow"
        ];
      };
    };
  };
}
