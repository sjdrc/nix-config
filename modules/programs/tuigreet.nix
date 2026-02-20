{...}: {
  flake.nixosModules.tuigreet = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.tuigreet.enable = lib.mkEnableOption "tuigreet display manager";

    config = lib.mkIf config.custom.programs.tuigreet.enable {
      services.greetd = {
        enable = true;
        greeterManagesPlymouth = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --user-menu --time --remember --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
            user = "greeter";
          };
        };
      };
    };
  };
}
