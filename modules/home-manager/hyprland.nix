{ inputs, config, pkgs, ... }:
{
  home.packages = with pkgs; [
    wofi
    brightnessctl
    networkmanagerapplet
    polkit_gnome
  ];

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.avizo.enable = true;

  # Status Bar
  # Idle Daemon
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          # Dim the screen after 2 minutes
          timeout = 120;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          # Turn off display after 5 minutes
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          # Lock the system after 10 minutes
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          # Sleep the system after 30 minutes
          timeout = 1800;
          on-timeout = "systemctl suspend-then-hibernate";
        }
      ];
    };
  };

  # Screen locker
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        grace = 300;
        no_fade_in = true;
        no_fade_out = true;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };

  # Window Manager
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      # Default applications
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      # Startup tools
      exec-once = [
        #"waybar"
        "nm-applet --indicator"
        "blueman-applet"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;

        resize_on_border = true;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layout configurations
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_is_master = true;
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      #input = {
      #  scroll_factor = 0.3;
      #};

      # Modifier key combos
      "$m1" = "SUPER";
      "$m2" = "SUPER SHIFT";

      bind = [
        # Application shortcuts
        "$m1, Space,          exec, $menu"
        "$m1, Return,         exec, $terminal"
        "$m2, N,              exec, $fileManager"
        "$m1, Escape,         exec, loginctl lock-session"

        # Window manager controls
        "$m1, W,              killactive,"
        "$m1, R,              togglesplit,"
        "$m1, F,              fullscreen,"
        "$m2, Q,              exit,"
        "$m2, F,              togglefloating,"

        "$m1, left,           movefocus, l"
        "$m1, right,          movefocus, r"
        "$m1, up,             movefocus, u"
        "$m1, down,           movefocus, d"

        "$m1, 1,              workspace, 1"
        "$m1, 2,              workspace, 2"
        "$m1, 3,              workspace, 3"
        "$m1, 4,              workspace, 4"
        "$m1, 5,              workspace, 5"
        "$m1, 6,              workspace, 6"
        "$m1, 7,              workspace, 7"
        "$m1, 8,              workspace, 8"
        "$m1, 9,              workspace, 9"
        "$m2, 0,              movetoworkspace, 10"
        "$m2, 1,              movetoworkspace, 1"
        "$m2, 2,              movetoworkspace, 2"
        "$m2, 3,              movetoworkspace, 3"
        "$m2, 4,              movetoworkspace, 4"
        "$m2, 5,              movetoworkspace, 5"
        "$m2, 6,              movetoworkspace, 6"
        "$m2, 7,              movetoworkspace, 7"
        "$m2, 8,              movetoworkspace, 8"
        "$m2, 9,              movetoworkspace, 9"
        "$m2, 0,              movetoworkspace, 10"

        # Scroll through existing workspaces with mouse scroll
        "$m1, mouse_down,     workspace, e+1"
        "$m1, mouse_up,       workspace, e-1"

        # Brightness and volume controls
        ",    XF86AudioLowerVolume,  exec, volumectl -u down"
        ",    XF86AudioRaiseVolume,  exec, volumectl -u up"
        ",    XF86AudioMute,         exec, volumectl toggle-mute"
        ",    XF86AudioMicMute,      exec, volumectl -m toggle-mute"
        ",    XF86MonBrightnessDown, exec, lightctl down"
        ",    XF86MonBrightnessUp,   exec, lightctl up"
      ];
      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$m1, mouse:272, movewindow"
        "$m1, mouse:273, movewindow"
      ];
    };
  };

  # Fix issue with running systemd services https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  # Status Bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 32;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          #"power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        tray = {
          icon-size = 24;
          spacing = 8;
        };
        clock = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          "format-icons" = [ "" "" "" ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [ "" "" "" "" "" ];
        };
        power-profiles-daemon = {
          format = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            "power-saver" = "";
          };
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = " {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
            headphone = "";
            "hands-free" = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          "format-icons" = {
            activated = "";
            deactivated = "";
          };
        };
      };
    };
  };
}
