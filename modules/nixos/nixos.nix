{ inputs, outputs, lib, config, pkgs, ... }:
{
  # NixOS configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes repl-flake";
  nix.settings.auto-optimise-store = true;

  # Nix helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean.enable = true;
    clean.extraArgs = "--keep 10 --keep-since 7d";
  };

  # WARNING: Do not change
  system.stateVersion = "24.05";
}

