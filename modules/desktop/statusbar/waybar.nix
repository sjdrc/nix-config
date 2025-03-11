{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.launcher;
  opt = "rofi";
in {
  options.desktop.statusbar = lib.custom.mkChoice opt;

  config = lib.custom.mkIfChosen cfg opt {
    fonts.packages = [pkgs.font-awesome];

    home-manager.users.sebastien = {
      services.blueman-applet.enable = true;
      services.network-manager-applet.enable = true;
      services.pasystray.enable = true;

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "bottom";
            height = 32;
            spacing = 4;
            # LEFT MODULES
            modules-left = [
              "hyprland/workspaces"
              "hyprland/submap"
            ];
            "hyprland/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
            };
            "hyprland/submap" = {
              format = "{}";
              tooltip = false;
            };
            # RIGHT MODULES
            modules-right = [
              "cpu"
              "memory"
              "temperature"
              "battery"
              "clock"
              "tray"
            ];
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
              format-icons = [
                ""
                ""
                ""
              ];
            };
            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-full = "{capacity}% {icon}";
              format-charging = "{capacity}% ";
              format-plugged = "{capacity}% ";
              format-alt = "{time} {icon}";
              format-icons = [
                ""
                ""
                ""
                ""
                ""
              ];
            };
            clock = {
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
            };
            tray = {
              icon-size = 24;
              spacing = 8;
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
                default = [
                  ""
                  ""
                  ""
                ];
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
    };
  };
}
