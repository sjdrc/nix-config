{
  config,
  lib,
  ...
}:
{
  options = {
    greeter = lib.mkOption {
      type = with lib.types; nullOr (enum ["regreet"]);
    };
  };

  config = lib.mkIf (config.greeter == "regreet") {
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
