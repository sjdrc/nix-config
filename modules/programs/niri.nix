{inputs, ...}: let
  homeModule = {
    inputs,
    pkgs,
    lib,
    config,
    osConfig,
    ...
  }: {
    options.custom.programs.niri = {
      launcherCommand = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Command to launch the application launcher";
      };
      terminalCommand = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Command to launch the terminal emulator";
      };
    };

    config = lib.mkIf osConfig.custom.programs.niri.enable {
      # User-level niri config
      services = {
        swaync.enable = true;
        swayosd = {
          enable = true;
          topMargin = 0.9;
        };
        swayidle = {
          enable = true;
          events = let
            command = "${pkgs.swaylock}/bin/swaylock -f";
          in {
            before-sleep = command;
            lock = command;
          };
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.systemd}/bin/loginctl lock-session";
            }
            {
              timeout = 300;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
              resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
            }
          ];
        };
      };

      programs.swaylock.enable = true;

      programs.niri.settings = lib.mkIf (config.lib ? niri) {
        xwayland-satellite.path = lib.getExe inputs.niri.packages.x86_64-linux.xwayland-satellite-unstable;
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        environment = {
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "wayland";
          QT_QPA_PLATFORM = "wayland";
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
          preset-column-widths = [
            {proportion = 1. / 3.;}
            {proportion = 1. / 2.;}
            {proportion = 2. / 3.;}
          ];
          empty-workspace-above-first = true;
          always-center-single-column = true;
        };
        binds = with config.lib.niri.actions; {
          # Program Hotkeys
          "Mod+Space".action.spawn = config.custom.programs.niri.launcherCommand;
          "Mod+Return".action.spawn = config.custom.programs.niri.terminalCommand;
          "Mod+Escape".action.spawn = ["loginctl" "lock-session"];
          "Mod+Shift+Escape".action.spawn = ["wlogout" "-p" "layer-shell"];

          # Utility Keys
          "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume" "lower"];
          "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume" "raise"];
          "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];
          "XF86AudioMicMute".action.spawn = ["swayosd-client" "--input-volume" "mute-toggle"];
          "XF86MonBrightnessDown".action.spawn = ["swayosd-client" "--brightness" "lower"];
          "XF86MonBrightnessUp".action.spawn = ["swayosd-client" "--brightness" "raise"];
          "Mod+Print".action.screenshot-window = [];
          "Mod+Shift+Print".action.screenshot = [];

          # General Keycombos
          "Mod+F".action = fullscreen-window;
          "Mod+R".action = switch-preset-column-width;
          "Mod+Tab".action = toggle-overview;
          "Mod+Shift+Q".action = close-window;
          "Mod+Shift+F".action = toggle-window-floating;

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
  };
in {
  nixosModule = {
    inputs,
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [inputs.niri.nixosModules.niri];

    options.custom.programs.niri.enable = lib.mkEnableOption "Niri window manager";

    config = lib.mkIf config.custom.programs.niri.enable {
      # System-level niri setup
      programs.niri.enable = true;
      programs.niri.package = inputs.niri.packages.x86_64-linux.niri-unstable;

      environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
      ];

      # The niri flake module handles xdg.portal enable, configPackages,
      # xdg-desktop-portal-gnome, and gnome-keyring. Add GTK fallback and
      # WLR portal for ScreenCast (niri's GNOME portal screencast has a
      # DMA-BUF format negotiation bug with browsers: niri#455, niri#2808).
      xdg.portal = {
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
        config.niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = ["gtk"];
          "org.freedesktop.impl.portal.Notification" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          # Use WLR portal for ScreenCast to work around niri's DMA-BUF
          # format negotiation bug with browsers (niri#455, niri#2808).
          "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
          "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        };
      };

      environment.sessionVariables = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
      };
    };
  };

  inherit homeModule;
}
