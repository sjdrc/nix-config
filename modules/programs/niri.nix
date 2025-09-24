{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  programs.niri.enable = true;
  programs.niri.package = inputs.niri.packages.x86_64-linux.niri-unstable;
  home-manager.users.sebastien = {config, ...}: {
    services = {
      swaync.enable = true;
      swayosd = {
        enable = true;
        margin = 0.9;
      };
      swayidle = {
        enable = true;
        events = let
          command = "${pkgs.swaylock}/bin/swaylock -f";
        in [
          {
            event = "before-sleep";
            inherit command;
          }
          {
            event = "lock";
            command = "${pkgs.swaylock}/bin/swaylock -f";
          }
        ];
        timeouts = [
          {
            timeout = 300;
            command = "loginctl lock-session";
          }
          {
            timeout = 600;
            command = "systemctl suspend";
          }
        ];
      };
    };
    programs.swaylock.enable = true;
    programs.rofi.enable = true;
    programs.niri.settings = {
      xwayland-satellite.path = lib.getExe inputs.niri.packages.x86_64-linux.xwayland-satellite-unstable;
      hotkey-overlay.skip-at-startup = true;
      clipboard.disable-primary = true;
      environment = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        QT_QPA_PLATFORM = "wayland";
        DISPLAY = null;
      };
      input = {
        focus-follows-mouse.enable = true;
        power-key-handling.enable = true;
      };
      cursor = {
        hide-when-typing = true;
        size = 16;
      };
      layout = {
        # Put this in host, varies with monitor
        #preset-column-widths = [
        #  {proportion = 1. / 3.;}
        #  {proportion = 1. / 2.;}
        #  {proportion = 2. / 3.;}
        #  {proportion = 1.;}
        #];
        always-center-single-column = true;
      };
      binds = with config.lib.niri.actions; {
        # Program Hotkeys
        "Mod+Space".action.spawn = ["rofi" "-show" "drun" "-show-icons"];
        "Mod+Return".action.spawn = ["kitty"];
        "Mod+Escape".action.spawn = ["loginctl" "lock-session"];

        # Utility Keys
        "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume" "lower"];
        "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume" "raise"];
        "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];
        "XF86AudioMicMute".action.spawn = ["swayosd-client" "--input-volume" "mute-toggle"];
        "XF86MonBrightnessDown".action.spawn = ["swayosd-client" "--brightness" "lower"];
        "XF86MonBrightnessUp".action.spawn = ["swayosd-client" "--brightness" "raise"];
        "Mod+Print".action = screenshot-window;
        "Mod+Shift+Print".action = screenshot;

        # General Keycombos
        "Mod+F".action = fullscreen-window;
        "Mod+R".action = switch-preset-column-width;
        "Mod+Tab".action = toggle-overview;
        "Mod+Shift+Q".action = close-window;
        "Mod+Shift+F".action = toggle-window-floating;
        "Mod+Shift+Escape".action = quit;

        # Focus Navigation
        "Mod+Up".action = focus-workspace-up;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Alt+Up".action = focus-window-up;
        "Mod+Alt+Down".action = focus-window-down;

        # Moving
        "Mod+Shift+Up".action = move-window-to-workspace-up;
        "Mod+Shift+Down".action = move-window-to-workspace-down;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Alt+Up".action = move-window-up;
        "Mod+Shift+Alt+Down".action = move-window-down;
      };
    };
  };
}
