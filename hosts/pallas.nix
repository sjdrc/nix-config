{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-pocket-3
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  #services.fprintd.enable = true;
  #environment.systemPackages = [
  #  pkgs.libfprint-focaltech-2808-a658
  #];

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp174s0";

  home-manager.users.sebastien.programs.niri.settings.layout.preset-column-widths = [
    {proportion = 1. / 2.;}
    {proportion = 1.;}
  ];
}
