{ inputs, outputs, lib, config, pkgs, ... }:
{
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
    outputs.nixosModules.nixos
    outputs.nixosModules.power
    outputs.nixosModules.stylix
  ];

  # System name
  networking.hostName = "ixion";

  # Networking
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # User account
  users.users.sebastien = {
    isNormalUser = true;
    description = "Sebastien";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git
    tmux
    wget
    firefox
  ];

  environment.sessionVariables = {
    # Force wayland for firefox
    MOZ_ENABLE_WAYLAND = "1";
  };
}
