{lib, ...}: {
  options = {
    hyprland.layout = lib.mkOption {
      description = "Hyprland layout to use";
      type = with lib.types; nullOr (enum []);
      default = "hyprscroller";
    };
  };

  imports = [
    ./hy3.nix
    ./hyprscroller.nix
  ];
}
