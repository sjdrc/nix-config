{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nur.url = "github:nix-community/NUR";

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

    gpd-fan-driver = {
      url = "github:Cryolitia/gpd-fan-driver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    hosts = map (host: builtins.replaceStrings [".nix"] [""] host) (builtins.attrNames (builtins.readDir ./hosts));
  in {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = nixpkgs.lib.genAttrs hosts (
      host:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./modules
            ./hosts/${host}.nix
            self.overlays
            inputs.nur.nixosModules.nur
            {networking.hostName = "${host}";}
          ];
          specialArgs = {inherit inputs;};
        }
    );

    homeConfigurations = inputs.nixpkgs.lib.genAttrs hosts (
      host: self.nixosConfigurations.${host}.config.home-manager.users.sebastien.home
    );
  };
}
