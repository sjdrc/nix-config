{pkgs, ...}: {
  services.gvfs.enable = true;
  programs.thunar.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  home-manager.users.sebastien = {
    gtk.enable = true;
    qt.enable = true;
  };

  environment.systemPackages = with pkgs; [wdisplays shikane];
}
