{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      globals = {
        user = "sebastien";
      };
    in
    {
      #packages = import ./pkgs {
      #  inherit
      #    inputs
      #    outputs
      #    system
      #    pkgs
      #    ;
      #};

      nixosConfigurations = {
        ixion = import ./hosts/ixion.nix {
          inherit
            inputs
            outputs
            globals
            system
            pkgs
            ;
        };
      };

      homeConfigurations = {
        ixion = self.nixosConfigurations.ixion.config.home-manager.users.${globals.user}.home;
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
      #formatter.${system} = pkgs.alejandra;
    };
}
