{
  lib,
  pkgs,
  ...
}: {
  imports = lib.custom.scanPaths ./.;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  home-manager.users.sebastien = {
    gtk.enable = true;
    qt.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wdisplays
    wl-clipboard
  ];
}
