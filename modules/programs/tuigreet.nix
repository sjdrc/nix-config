{
  config,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    #greeterManagesPlymouth = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --time --remember --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };
}
