{inputs, ...}: {
  flake.homeModules.nix = {osConfig, lib, ...}: lib.mkIf osConfig.custom.nix.enable {
    programs.nix-index-database.comma.enable = true;
    programs.nix-index.enable = true;
  };

  flake.nixosModules.nix = {config, pkgs, lib, ...}: {
    imports = [
      inputs.determinate.nixosModules.default
      inputs.nix-index-database.nixosModules.nix-index
    ];

    options.custom.nix.enable =
      lib.mkEnableOption "nix configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.nix.enable {
      nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];
      nix.settings.auto-optimise-store = true;
      nix.settings.trusted-users = ["@wheel" "root"];
      nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      nix.extraOptions = ''
        accept-flake-config = true
      '';

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

      environment.systemPackages = with pkgs; [
        nix-inspect
        nix-output-monitor
        manix
        alejandra
      ];

      home-manager.sharedModules = [
        inputs.nix-index-database.homeModules.nix-index
      ];

      # WARNING: Do not change
      system.stateVersion = "24.05";
    };
  };
}
