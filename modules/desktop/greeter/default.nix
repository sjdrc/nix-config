{lib, ...}: {
  imports = lib.custom.scanPaths ./.;

  options.desktop.greeter = lib.mkOption {
    description = "Display manager to use";
    type = with lib.types; nullOr (enum []);
    default = "regreet";
  };
}
