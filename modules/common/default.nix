{ config, pkgs, ... }:
{
  imports = [
    ./home-manager.nix
    ./locale.nix
    ./nixos.nix
    ./stylix.nix
  ];

  home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      bambu-studio
      orca-slicer
    ];
  };
}
