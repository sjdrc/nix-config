{ pkgs, ... }:
{
  boot.plymouth.enable = true;
  boot.plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];
  boot.plymouth.theme = "nixos-bgrt";

  # Make boot messages as quiet as possible
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
}
