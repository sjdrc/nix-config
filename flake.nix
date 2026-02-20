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

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports =
        [
          # Declare mergeable options so multiple module files can each
          # contribute flake.<output>.<name> without conflicting.
          # flake-parts' freeform type (lazyAttrsOf raw) cannot merge when
          # more than one module sets the same top-level key, so we need
          # explicit option declarations for any key set by multiple files.
          ({lib, ...}: {
            options.flake.nixosModules = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = {};
            };
            options.flake.nixosConfigurations = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = {};
            };
            options.flake.homeModules = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.raw;
              default = {};
            };
          })
        ]
        # Auto-import all .nix files from these directories (dendritic pattern)
        ++ builtins.concatMap
        (dir:
          builtins.map (f: dir + "/${f}")
          (builtins.filter (f: f != "default.nix" && builtins.match ".*\\.nix" f != null)
            (builtins.attrNames (builtins.readDir dir))))
        [./modules/system ./modules/programs ./modules/profiles ./modules/hardware ./hosts ./packages];

      flake = {
        # Custom lib
        lib = inputs.nixpkgs.lib.extend (self: super: {
          custom = import ./lib {inherit (inputs.nixpkgs) lib;};
        });

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
    });
}
