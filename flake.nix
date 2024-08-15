{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #stylix.url = "github:danth/stylix";
    #stylix.inputs.nixpkgs.follows = "nixpkgs";
    #stylix.inputs.home-manager.follows = "home-manager";

    catppuccin.url = "github:catppuccin/nix";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.additions
          self.overlays.modifications
        ];
      };
    in
    {
      overlays = import ./overlays { };

      nixosConfigurations = {
        ixion = import ./hosts/ixion.nix { inherit inputs system pkgs; };
      };

      homeConfigurations = with self.nixosConfigurations.ixion.config; {
        ixion = home-manager.users.${user}.home;
      };

      formatter.${system} = pkgs.nixfmt-rfc-style;
    };
}
