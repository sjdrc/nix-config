{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.greeter;
  opt = "regreet";
in {
  options.desktop.greeter = lib.custom.mkChoice opt;

  config = lib.custom.mkIfChosen cfg opt {
    services.greetd = {
      enable = true;
      greeterManagesPlymouth = true;
    };

    programs.regreet = {
      enable = true;
      cageArgs = [
        # Allow TTY switching
        "-s"
        # Only display on the monitor last connected
        "-m"
        "last"
      ];
    };
  };
}
