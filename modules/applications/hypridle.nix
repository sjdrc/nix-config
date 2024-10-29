{ pkgs, ... }:
let
  lock = "loginctl lock-session";
  screenOn = "hyprctl dispatch dpms on";
  screenOff = "hyprctl dispatch dpms off";
in
{
  hmConfig = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [ "$m1, Escape, exec, ${lock}" ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          ignore_dbus_inhibit = false;
          lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = lock;
          after_sleep_cmd = screenOn;
        };
        listener = [
          {
            timeout = 120;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            timeout = 300;
            on-timeout = lock;
          }
          {
            timeout = 360;
            on-timeout = screenOff;
            on-resume = screenOn;
          }
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
