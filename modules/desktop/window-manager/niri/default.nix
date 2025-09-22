{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports =
    lib.custom.scanPaths ./.
    ++ [
      inputs.niri.nixosModules.niri
    ];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
  environment.systemPackages = [pkgs.alacritty];
  home-manager.users.sebastien = {
    services.swayosd = {
      enable = true;
      topMargin = 0.9;
    };
    programs.niri.settings.binds = with config.lib.niri.actions; {
      "Mod+Space".action.spawn = ["rofi" "-show" "drun" "-show-icons"];
      "Mod+Return".action.spawn = ["kitty"];
      "XF86AudioLowerVolume".action.spawn = ["swayosd-client" "--output-volume" "lower"];
      "XF86AudioRaiseVolume".action.spawn = ["swayosd-client" "--output-volume" "raise"];
      "XF86AudioMute".action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];
      "XF86AudioMicMute".action.spawn = ["swayosd-client" "--input-volume" "mute-toggle"];
      "XF86MonBrightnessDown".action.spawn = ["swayosd-client" "--brightness" "lower"];
      "XF86MonBrightnessUp".action.spawn = ["swayosd-client" "--brightness" "raise"];
      "Mod+F".action = fullscreen;
      "Mod".action.spawn = [""];
    };
  };
}
