{ lib, ... }:
{
  options = {
    hyprland = {
      statusbar = lib.mkOption {
        description = "Status bar to use";
        type = with lib.types; nullOr (enum []);
        default = "waybar";
      };
    };
  };

  imports = lib.custom.scanPaths ./.;

}
