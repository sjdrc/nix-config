{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:sjdrc/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Hyprland and friends #############
    hyprland = {
      url = "https://github.com/hyprwm/Hyprland";
      type = "git";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
      #inputs.aquamarine.url = "github:hyprwm/aquamarine";
    };

    hypridle = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprland";
        hyprlang.follows = "hyprland";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprland";
        hyprlang.follows = "hyprland";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        hyprutils.follows = "hyprland";
        hyprlang.follows = "hyprland";
        hyprwayland-scanner.follows = "hyprland";
      };
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };

    hyprscroller = {
      url = "github:dawsers/hyprscroller";
      inputs.hyprland.follows = "hyprland";
    };

    gpd-fan-driver = {
      url = "github:Cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.ixion = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/ixion.nix
          (import ./overlays)
        ];
        specialArgs = {
          inherit inputs;
        };
      };

      homeConfigurations = with self.nixosConfigurations.ixion.config; {
        ixion = home-manager.users.${user}.home;
      };
    };
}
