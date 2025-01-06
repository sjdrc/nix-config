{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hyprshot
    hyprpicker
  ];

  home-manager.users.sebastien = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          # Screenshot a monitor
          ",                 PRINT,            exec, hyprshot -m output"
          # Screenshot a window
          "$MOD,             PRINT,            exec, hyprshot -m window"
          # Screenshot a region
          "$MOD+SHIFT,       PRINT,            exec, hyprshot -m region"
        ];
      };
    };
  };
}
