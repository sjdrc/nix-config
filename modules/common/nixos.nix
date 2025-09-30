{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  # NixOS configuration
  nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
  nix.settings.auto-optimise-store = true;
  nix.settings.trusted-users = ["@wheel" "root"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.extraOptions = ''
    accept-flake-config = true
  '';

  # Nix helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean.enable = true;
    clean.extraArgs = "--keep 10 --keep-since 7d";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
  # Flake config inspection tool
  environment.systemPackages = with pkgs; [
    nix-inspect
    nix-output-monitor
    manix
    alejandra
  ];

  home-manager.sharedModules = [inputs.nix-index-database.homeModules.nix-index];
  home-manager.users.sebastien = {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true;
  };

  # WARNING: Do not change
  system.stateVersion = "24.05";
}
