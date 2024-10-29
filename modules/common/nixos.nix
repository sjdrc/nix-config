{ pkgs, ... }:
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

  # Flake config inspection tool
  environment.systemPackages = [ pkgs.nix-inspect ];

  hmConfig = {
    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    home.packages = with pkgs; [
      nixd
      nil
      nixfmt-rfc-style
    ];
  };

  # WARNING: Do not change
  system.stateVersion = "24.05";
}
