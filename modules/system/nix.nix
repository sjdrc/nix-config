{inputs, ...}: {
  nixosModule = {
    inputs,
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      inputs.determinate.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

    options.custom.system.nix.enable =
      lib.mkEnableOption "nix configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.nix.enable {
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

      # Flake config inspection tools
      environment.systemPackages = with pkgs; [
        nix-inspect
        nix-output-monitor
        manix
        alejandra
      ];

      # Home-manager integration for nix-index
      # Note: The home-manager user-specific config is in programs/nix-tools.nix
      home-manager.sharedModules = [inputs.nix-index-database.homeModules.nix-index];

      # WARNING: Do not change
      system.stateVersion = "24.05";
    };
  };
}
