{
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland-plugins/hypr-dynamic-cursor.nix
    ./hyprland-plugins/hyprscroller.nix
    #./hyprland-plugins/hycov.nix
    #./hyprland-plugins/hyprexpo.nix
    #./hyprland-plugins/hyprgrass.nix
    #./hyprland-plugins/hyprspace.nix
    #./hyprland-plugins/hy3.nix
  ];

  programs.hyprland.enable = true;

  environment.sessionVariables = {
    # Force wayland for electron applications
    NIXOS_OZONE_WL = "1";
  };

  home-manager.users.${config.user} = {
    home.packages = with pkgs; [ polkit_gnome ];

    # Window Manager
    wayland.windowManager.hyprland = {
      enable = true;
      # Fix issue with running systemd services https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      systemd.variables = [ "--all" ];

      plugins = [ outputs.packages.hypr-workspace-layouts ];

      settings = {
        # Default applications
        "$fileManager" = "dolphin";

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
        };

        workspace = [ "name:personal, " ];

        # Modifier key combos
        "$m1" = "SUPER";
        "$m2" = "SUPER SHIFT";

        bind = [
          # Application shortcuts
          "$m1, Space,          exec, $launcher"
          "$m1, Return,         exec, $terminal"
          "$m2, N,              exec, $fileManager"

          # Window manager controls
          "$m1, F,              fullscreen, 1"
          "$m2, Q,              killactive,"
          "$m2, F,              togglefloating, active"
          "$m2, P,              pin, active"

          "$m1, 1,              workspace, 1"
          "$m1, 2,              workspace, 2"
          "$m1, 3,              workspace, 3"
          "$m1, 4,              workspace, 4"
          "$m1, 5,              workspace, 5"
          "$m1, 6,              workspace, 6"
          "$m1, 7,              workspace, 7"
          "$m1, 8,              workspace, 8"
          "$m1, 9,              workspace, 9"

          "$m2, 1,              movetoworkspacesilent, 1"
          "$m2, 2,              movetoworkspacesilent, 2"
          "$m2, 3,              movetoworkspacesilent, 3"
          "$m2, 4,              movetoworkspacesilent, 4"
          "$m2, 5,              movetoworkspacesilent, 5"
          "$m2, 6,              movetoworkspacesilent, 6"
          "$m2, 7,              movetoworkspacesilent, 7"
          "$m2, 8,              movetoworkspacesilent, 8"
          "$m2, 9,              movetoworkspacesilent, 9"
          "$m2, 0,              movetoworkspacesilent, 10"
        ];
        #bindm = [
        #  # Move/resize windows with mod + LMB/RMB and dragging
        #  "$m1, mouse:272, movewindow"
        #  "$m1, mouse:273, movewindow"
        #];
      };
    };
  };
}
