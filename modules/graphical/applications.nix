{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      bambu-studio
      orca-slicer
      signal-desktop
    ];
  };
}
