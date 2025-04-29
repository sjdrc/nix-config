{
  description = "NixOS configuration";

  nixConfig = {
    extra-trusted-substituters = [
      "https://cache.flakehub.com/"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio="
      "cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU="
      "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU="
      "cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8="
      "cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ= "
      "cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o="
      "cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    nvf.url = "github:notashelf/nvf";

    stylix.url = "https://flakehub.com/f/danth/stylix/0.1.*";

    blackai.url = "github:sjdrc/blackai-nix";
    blackai.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend (self: super: {custom = import ./lib {inherit (nixpkgs) lib;};});
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs lib.custom.getHostsList (
      host:
        nixpkgs.lib.nixosSystem {
          modules = [
            ./modules
            ./hosts/${host}.nix
            {networking.hostName = "${host}";}
            inputs.blackai.nixosModules.blackai
          ];
          specialArgs = {inherit inputs lib;};
        }
    );

    homeConfigurations."sebastien@ariel".config = self.nixosConfigurations.ariel.config.home-manager.users.sebastien;
  };
}
