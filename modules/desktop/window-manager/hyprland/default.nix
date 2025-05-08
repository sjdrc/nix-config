{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = lib.custom.scanPaths ./.;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  services.hyprpolkitagent.enable = true;

  home-manager.users.sebastien = {
    wayland.windowManager.hyprland = {
      enable = true;

      systemd.enable = false;

      settings = {
        env =
          [
            # Force wayland for electron applications
            "NIXOS_OZONE_WL,1"
          ]
          ++ lib.optionals config.hardware.nvidia.enabled [
            "LIBVA_DRIVER_NAME,nvidia"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          ];

        cursor.no_hardware_cursors = true;

        debug.disable_logs = false;

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

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

        xwayland = {
          force_zero_scaling = true;
        };

        monitor = [
          ", preferred, auto, 1"
        ];

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
          swallow_regex = ["^(kitty)$"];
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        windowrulev2 = [
          "float, class:^(org.gnome.NautilusPreviewer)$"
          "float, class:(xdg-desktop-portal-gtk) title:^(.*)(Open|Save)(.*)$"
        ];

        workspace = [
          "1,               defaultName:main"
          "2,               defaultName:work"
          "3,               defaultName:comms"
        ];

        # Modifier key combos
        "$MOD" = "SUPER";
        "$MOD+SHIFT" = "SUPER SHIFT";
        "$MOD+CTRL" = "SUPER CTRL";
        "$MOD+ALT" = "SUPER ALT";

        bind = [
          # Application shortcuts
          "$MOD,             Space,            exec, $launcher"
          "$MOD,             Return,           exec, $terminal"
          "$MOD+SHIFT,       N,                exec, $fileManager"

          # Window controls
          "$MOD,             F,                fullscreen, 1"
          "$MOD+SHIFT,       Q,                killactive,"
          "$MOD+SHIFT,       F,                togglefloating, active"
          "$MOD+SHIFT,       P,                pin, active"

          # Workspace controls
          "$MOD,             1,                workspace, 1"
          "$MOD,             2,                workspace, 2"
          "$MOD,             3,                workspace, 3"
          "$MOD+SHIFT,       1,                movetoworkspacesilent, 1"
          "$MOD+SHIFT,       2,                movetoworkspacesilent, 2"
          "$MOD+SHIFT,       3,                movetoworkspacesilent, 3"

          # Scrach workspace
          "$MOD,             S,                togglespecialworkspace"
          "$MOD+SHIFT,       S,                movetoworkspacesilent, special"
          "$MOD+CTRL,        S,                movetoworkspacesilent, e+0"
        ];
        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$MOD,             mouse:272,        movewindow"
          "$MOD,             mouse:273,        movewindow"
        ];
      };
    };
  };
}
