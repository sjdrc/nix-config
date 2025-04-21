{
  lib,
  pkgs,
  ...
}: {
  imports = lib.custom.scanPaths ./.;

  services.gvfs.enable = true;

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
