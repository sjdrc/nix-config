{ inputs, outputs, lib, config, pkgs, ...}:
{
  imports = [
    ./hardware.nix
    outputs.nixosModules.gaming
	outputs.nixosModules.greetd
	outputs.nixosModules.hyprland
	outputs.nixosModules.nixos
	outputs.nixosModules.power
	outputs.nixosModules.stylix
  ];
  
  # System name
  networking.hostName = "ixion";
  
  # Time zone and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale =  "en_AU.UTF-8";

  # User account
  users.users.sebastien = {
    isNormalUser = true;
    description = "Sebastien";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Networking
  networking.networkmanager.enable = true;

  services.tailscale = {
    enable = true;
	useRoutingFeatures = "client";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    git
	tmux
	wget
    firefox
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.sessionVariables = {
	# Force wayland for firefox
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
