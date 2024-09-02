{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.aquamarine.url = "github:hyprwm/aquamarine";
    };

    hypridle = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprland";
      inputs.hyprlang.follows = "hyprland";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprland";
      inputs.hyprlang.follows = "hyprland";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprutils.follows = "hyprland";
      inputs.hyprlang.follows = "hyprland";
      inputs.hyprwayland-scanner.follows = "hyprland";
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
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      overlays = import ./overlays { inherit inputs; };

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

      #formatter =.nixfmt-rfc-style;
    };
}
