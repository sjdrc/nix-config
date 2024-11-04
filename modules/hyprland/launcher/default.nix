{ lib, ... }:
{
  options = {
    hyprland = {
      launcher = lib.mkOption {
        description = "Launcher to use";
        type = with lib.types; nullOr (enum []);
        default = "rofi";
      };
    };
  };

  imports = [
    ./rofi.nix
  ];
}
