{ inputs, outputs, lib, config, pkgs, ... }:
{
  networking.hostName = "ixion";
  
  imports = [
    ./hardware-configuration.nix
    #outputs.nixosModules.audio
    outputs.nixosModules.bluetooth
    outputs.nixosModules.console
    outputs.nixosModules.gaming
    outputs.nixosModules.gpd-win-4
    outputs.nixosModules.graphics
    outputs.nixosModules.greetd
    outputs.nixosModules.hyprland
    outputs.nixosModules.locale
    outputs.nixosModules.networking
    outputs.nixosModules.nixos
    outputs.nixosModules.power
    outputs.nixosModules.stylix
  ];

  users.users.sebastien = {
    isNormalUser = true;
    description = "Sebastien";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    firefox
  ];

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";           # Force wayland for firefox
  };
}