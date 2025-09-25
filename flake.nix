{
  description = "NixOS configuration";

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
    home-manager.url = "github:nix-community/home-manager";
    determinate.url = "github:DeterminateSystems/determinate";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix";
    blackai.url = "github:sjdrc/blackai-nix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    disko.url = "github:nix-community/disko/latest";
    niri.url = "github:sodiboo/niri-flake";
  };
  outputs = inputs@{
    self,
    nixpkgs,
    flake-parts,
    ...
  }: let
    getHostsList = map (host: builtins.replaceStrings [".nix"] [""] host) (builtins.attrNames (builtins.readDir ./hosts));
  in flake-parts.lib.mkFlake { inherit inputs; } ({ config, withSystem, ...}: {
    imports = [
      inputs.flake-parts.flakeModules.flakeModules
      inputs.flake-parts.flakeModules.modules
      inputs.home-manager.flakeModules.home-manager
      ./flake
    ];
    systems = ["x86_64-linux"];
    flake = {
      nixosConfigurations = nixpkgs.lib.genAttrs getHostsList (
        host:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/${host}.nix
            {networking.hostName = "${host}";}
            inputs.blackai.nixosModules.blackai
            inputs.determinate.nixosModules.default
            config.flake.nixosModules.default
            {home-manager.sharedModules = [config.flake.homeModules.default];}
          ];
          specialArgs = {inherit inputs;};
        }
      );
      homeConfigurations."sebastien@ariel" = withSystem "x86_64-linux" ({pkgs,...}: inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          config.flake.homeModules.default
        ];
      });
    };
  });
}
