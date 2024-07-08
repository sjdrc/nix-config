{ inputs, lib, config, pkgs, ... }:
{
  services.greetd.enable = true;
  services.greetd.settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --user-menu --time --remember --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
      user = "greeter";
    };
  };

  #programs.regreet.enable = true;

  #environment.systemPackages = with pkgs; [
  #  cage
  #];

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}
