{ lib, ... }:
{
  options = {
    desktop = {
      hyprland.layout = lib.mkOption {
        description = "Hyprland layout to use";
        type = with lib.types; nullOr (enum [ ]);
        default = "hy3";
      };
      bar = lib.mkOption {
        description = "Status bar to use";
        type = with lib.types; nullOr (enum [ ]);
        default = "waybar";
      };
      launcher = lib.mkOption {
        description = "Launcher to use";
        type = with lib.types; nullOr (enum [ ]);
        default = "rofi";
      };
    };
  };

  config = {
    services.gvfs.enable = true;
    programs.thunar.enable = true;

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    hmConfig = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
