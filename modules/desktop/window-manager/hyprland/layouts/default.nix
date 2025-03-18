{lib, ...}: {
  options = {
    hyprland.layout = lib.mkOption {
      description = "Hyprland layout to use";
      type = with lib.types; nullOr (enum []);
      default = "hy3";
    };
  };

  imports = lib.custom.scanPaths ./.;
}
