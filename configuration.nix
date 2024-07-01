{ inputs, outputs, lib, config, pkgs, ...}:
{
  imports = [
    ./hardware.nix
    outputs.nixosModules.gaming
	outputs.nixosModules.greetd
	outputs.nixosModules.hyprland
	outputs.nixosModules.power
	outputs.nixosModules.stylix
  ];
  
  # System name
  networking.hostName = "ixion";
  
  # Time zone and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale =  "en_AU.UTF-8";

  # NixOS configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes repl-flake";
    auto-optimise-store = true;
  };

  # Nix helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 10";
	flake = "/etc/nixos";
  };
  
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
