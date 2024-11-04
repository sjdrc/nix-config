{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland.launcher = lib.mkOption {
      type = with lib.types; nullOr (enum ["rofi"]);
    };
  };

  config = lib.mkIf (config.hyprland.launcher == "rofi") {
    home-manager.users.sebastien = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
      wayland.windowManager.hyprland.settings."$launcher" = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
    };
  };
}
