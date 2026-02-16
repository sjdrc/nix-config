{
  description = "NixOS configuration with nixos-unified";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-unified.url = "github:srid/nixos-unified";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Existing inputs
    determinate.url = "github:DeterminateSystems/determinate";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    disko.url = "github:nix-community/disko/latest";
    niri.url = "github:sodiboo/niri-flake";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    prismlauncher-cracked.url = "github:Diegiwg/PrismLauncher-Cracked";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports = [
        inputs.nixos-unified.flakeModule
      ];

      flake = {
        # Custom lib (keep existing)
        lib = inputs.nixpkgs.lib.extend (self: super: {
          custom = import ./lib {inherit (inputs.nixpkgs) lib;};
        });

        # Overlays (keep existing)
        overlays.default = final: prev: {
          bambu-studio = final.callPackage ./packages/bambu-studio {};
          openlens = final.callPackage ./packages/openlens {};
        };

        # Use loader module to import all our custom modules
        nixosModules.default = ./modules-loader.nix;

        # Home modules for standalone home-manager (also used in homeConfigurations)
        homeModules.default = ./homeModules-loader.nix;

        # Standalone home-manager configurations (for cross-platform IDE support)
        homeConfigurations.sebastien = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
          extraSpecialArgs = {inherit inputs;};
          modules = [
            inputs.stylix.homeManagerModules.stylix
            inputs.self.homeModules.default
            {
              home.username = "sebastien";
              home.homeDirectory = "/home/sebastien";
              home.stateVersion = "24.05";
              programs.home-manager.enable = true;
            }
          ];
        };

        # NixOS configurations
        nixosConfigurations = let
          hostsList = inputs.self.lib.custom.getHostsList;
        in
          inputs.nixpkgs.lib.genAttrs hostsList (
            host:
              inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                  inputs.self.nixosModules.default
                  ./hosts/${host}.nix
                  {networking.hostName = host;}
                  {nixpkgs.overlays = [inputs.self.overlays.default];}

                ];
                specialArgs = {
                  inherit inputs;
                  lib = inputs.self.lib;
                };
              }
          );
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        packages = {
          bambu-studio = pkgs.callPackage ./packages/bambu-studio {};
          openlens = pkgs.callPackage ./packages/openlens {};
        };
      };
    };
}
