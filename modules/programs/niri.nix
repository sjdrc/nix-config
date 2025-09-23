{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
  security.pam.services.swaylock = {};
  environment.systemPackages = [pkgs.alacritty];
  home-manager.users.sebastien = {config, ...}: {
    services = {
      swaync.enable = true;
      swayosd.enable = true;
      swayidle.enable = true;
      swayidle.timeouts = [
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
    programs.swaylock.enable = true;
    programs.rofi.enable = true;
    programs.niri.settings.binds = with config.lib.niri.actions; {
      "Mod+Space".action.spawn = ["rofi" "-show" "drun" "-show-icons"];
      "Mod+Return".action.spawn = ["kitty"];
      "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume" "lower"];
      "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume" "raise"];
      "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];
      "XF86AudioMicMute".action.spawn = ["swayosd-client" "--input-volume" "mute-toggle"];
      "XF86MonBrightnessDown".action.spawn = ["swayosd-client" "--brightness" "lower"];
      "XF86MonBrightnessUp".action.spawn = ["swayosd-client" "--brightness" "raise"];
      "Mod+F".action = fullscreen-window;
      "Mod+Shift+Q".action = close-window;
      "Mod+Shift+F".action = toggle-window-floating;
      "Mod+Up".action = focus-workspace-up;
      "Mod+Down".action = focus-workspace-down;
      "Mod+Shift+Up".action = move-window-to-workspace-up;
      "Mod+Shift+Down".action = move-window-to-workspace-down;
      "Mod+Shift+Escape".action.spawn = ["loginctl" "lock-session"];
      "Mod+Print".action = screenshot-window;
      "Mod+Shift+Print".action = screenshot;
    };
  };
}
