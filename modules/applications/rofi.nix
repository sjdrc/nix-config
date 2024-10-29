{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    desktop.launcher = lib.mkOption {
      type = with lib.types; nullOr (enum [ "rofi" ]);
    };
  };

  config = lib.mkIf (config.desktop.launcher == "rofi") {
    hmConfig = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
      };
      wayland.windowManager.hyprland.settings."$launcher" = "${pkgs.rofi-wayland}/bin/rofi -show drun -show-icons";
    };
  };
}
