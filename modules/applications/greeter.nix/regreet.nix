{
  config,
  lib,
  ...
}:
let
  home = "/run/greeter";
in
{
  options = {
    greeter = lib.mkOption {
      type = with lib.types; nullOr (enum [ "regreet" ]);
    };
  };

  config = lib.mkIf (config.greeter == "regreet") {
    services.greetd = {
      enable = true;
      greeterManagesPlymouth = true;
    };

    programs.regreet = {
      enable = true;
      theme = with config.hmConfig.gtk.theme; {
        name = name;
        package = package;
      };
      font = with config.stylix.fonts; {
        name = sansSerif.name;
        package = sansSerif.package;
        size = sizes.applications;
      };
      cursorTheme = with config.stylix.cursor; {
        name = name;
        package = package;
      };
      cageArgs = [
        # Allow TTY switching
        "-s"
        # Only display on the monitor last connected
        "-m"
        "last"
      ];
    };

    users.users.greeter = {
      home = home;
      createHome = true;
    };

    home-manager.users.greeter.home = {
      username = "greeter";
      homeDirectory = home;
      stateVersion = "24.05";
    };
  };
}
