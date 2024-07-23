{ config, pkgs, ... }:
{
  programs.regreet = {
    enable = true;
    cageArgs = [
      # Only display on the monitor last connected
      "-m"
      "last"
      # Allow TTY switching
      "-s"
    ];
  };

  environment.systemPackages = with pkgs; [ cage ];

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
