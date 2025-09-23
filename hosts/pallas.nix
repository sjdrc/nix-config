{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-pocket-3
  ];

  #services.iio-hyprland.enable = true;

  home-manager.users.sebastien = {
    wayland.windowManager.hyprland.settings = {
      monitor = ["DSI-1, preferred, auto, 1.5, transform, 3"];
      input.touchpad.disable_while_typing = false;
    };
  };

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  services.fprintd.enable = true;
  environment.systemPackages = [
    pkgs.libfprint-focaltech-2808-a658
  ];

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp174s0";
  home-manager.users.sebastien.programs.niri.settings.layout.preset-column-widths = [
    {proportion = 1. / 2.;}
    {proportion = 1.;}
  ];
}
