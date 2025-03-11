{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.launcher;
  opt = "rofi";
in {
  options.desktop.launcher = lib.custom.mkChoice opt;

  config = lib.custom.mkIfChosen cfg opt {
    home-manager.users.sebastien = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
      wayland.windowManager.hyprland.settings."$launcher" = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
    };
  };
}
