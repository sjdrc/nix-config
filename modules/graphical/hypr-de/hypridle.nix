{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [ "$m1, Escape, exec, loginctl lock-session" ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            # 2m: Dim the screen
            timeout = 120;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            # 5m: Lock the system
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            # 6m: Turn off display
            timeout = 360;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            # 10m: Sleep the system
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
