{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hyprshot
    hyprpicker
  ];

  hmConfig = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          # Screenshot a monitor
          "   , PRINT,          exec, hyprshot -m output"
          # Screenshot a window
          "$m1, PRINT,          exec, hyprshot -m window"
          # Screenshot a region
          "$m2, PRINT,          exec, hyprshot -m region"
        ];
      };
    };
  };
}
