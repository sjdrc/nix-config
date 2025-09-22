{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  target = config.home-manager.users.sebastien.wayland.systemd.target;
in {
  options.services.iio-hyprland = {
    enable = mkEnableOption "A simple polkit authentication agent for Hyprland, written in QT/QML";
  };

  config = {
    environment.systemPackages = [pkgs.jq];

    programs.iio-hyprland.enable = true;

    home-manager.users.sebastien = {
      systemd.user.services.iio-hyprland = {
        Unit = {
          Description = "Rotate My Hyprland!";
          After = [target "post-resume.target"];
          PartOf = [target "post-resume.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        Service = {
          ExecStart = "${pkgs.iio-hyprland}/bin/iio-hyprland DSI-1";
          Slice = "session.slice";
          TimeoutStopSec = "5sec";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = ["post-resume.target" "graphical-session.target"];
        };
      };
    };
  };
}
