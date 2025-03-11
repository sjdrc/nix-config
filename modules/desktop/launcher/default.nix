{lib, ...}: {
  imports = lib.custom.scanPaths ./.;

  options.desktop.launcher = lib.mkOption {
    description = "Launcher to use";
    type = with lib.types; nullOr (enum []);
    default = "rofi";
  };
}
