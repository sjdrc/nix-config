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
  nix.extraOptions = ''
    accept-flake-config = true
  '';

  # Nix helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 10 --keep-since 7d";
  };

  environment.sessionVariables.FLAKE = "git+ssh://git@github.com/sjdrc/nix-config";

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
