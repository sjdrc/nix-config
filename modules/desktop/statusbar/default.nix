{lib, ...}: {
  imports = lib.custom.scanPaths ./.;

  options.desktop.statusbar = lib.mkOption {
    description = "Status bar to use";
    type = with lib.types; nullOr (enum []);
    default = "waybar";
  };
}
