{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://ai.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1.*";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

    nix-index-database.url = "github:nix-community/nix-index-database";

    nixos-hardware.url = "https://flakehub.com/f/NixOS/nixos-hardware/0.1.*";

    zen-browser.url = "https://flakehub.com/f/youwen5/zen-browser/0.1.*";

    nixvim.url = "https://flakehub.com/f/nix-community/nixvim/0.1.*";

    stylix.url = "https://flakehub.com/f/danth/stylix/0.1.*";

    kolide-launcher.url = "github:kolide/nix-agent/main";

  };

  outputs = {self, ...}@inputs: let
    hosts = map (host: builtins.replaceStrings [".nix"] [""] host) (builtins.attrNames (builtins.readDir ./hosts));
  in {
    nixosConfigurations = inputs.nixpkgs.lib.genAttrs hosts (
      host:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./modules
            ./hosts/${host}.nix
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
