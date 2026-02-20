{
  description = "NixOS configuration — dendritic flake-parts modules";

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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    # Auto-discover all .nix files in a directory and return their paths
    importModules = dir: let
      files = builtins.attrNames (builtins.readDir dir);
      nixFiles = builtins.filter (f: f != "default.nix" && builtins.match ".*\\.nix" f != null) files;
    in
      map (f: dir + "/${f}") nixFiles;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports =
        [inputs.nixos-unified.flakeModule]
        # Auto-import all module files as flake-parts modules (dendritic pattern)
        ++ importModules ./modules/system
        ++ importModules ./modules/programs
        ++ importModules ./modules/profiles
        ++ importModules ./modules/hardware
        # Auto-import all host files as flake-parts modules
        ++ importModules ./hosts;

      flake = {
        # Custom lib
        lib = inputs.nixpkgs.lib.extend (self: super: {
          custom = import ./lib {inherit (inputs.nixpkgs) lib;};
        });

        # Overlays
        overlays.default = final: prev: {
          bambu-studio = final.callPackage ./packages/bambu-studio {};
          orca-slicer = final.callPackage ./packages/orca-slicer {};
          openlens = final.callPackage ./packages/openlens {};
        };

        # Aggregate all named nixosModules into a single default module
        nixosModules.default = {...}: {
          imports = builtins.attrValues (builtins.removeAttrs config.flake.nixosModules ["default"]);
        };

        # Aggregate all named homeModules into a single default module
        homeModules.default = {...}: {
          imports = builtins.attrValues (builtins.removeAttrs config.flake.homeModules ["default"]);
        };

        # Standalone home-manager configurations (for cross-platform IDE support)
        homeConfigurations.sebastien = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
          extraSpecialArgs = {inherit inputs;};
          modules = [
            inputs.stylix.homeModules.stylix
            config.flake.homeModules.default
            {
              home.username = "sebastien";
              home.homeDirectory = "/home/sebastien";
              home.stateVersion = "24.05";
              programs.home-manager.enable = true;
            }
          ];
        };
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        packages = {
          bambu-studio = pkgs.callPackage ./packages/bambu-studio {};
          orca-slicer = pkgs.callPackage ./packages/orca-slicer {};
          openlens = pkgs.callPackage ./packages/openlens {};
        };
      };
    });
}
