{
  inputs,
  pkgs,
  ...
}: {
  # NixOS configuration
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.settings.allowed-users = ["sebastien"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  nix.settings = {
    trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://ai.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];
  };

  # Nix helper
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean.enable = true;
    clean.extraArgs = "--keep 10 --keep-since 7d";
  };

  # Flake config inspection tool
  environment.systemPackages = [pkgs.nix-inspect];

  home-manager.users.sebastien = {
    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
      alejandra
    ];
  };

  # WARNING: Do not change
  system.stateVersion = "24.05";
}
