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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:sjdrc/nixos-hardware";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

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

    #vscode-server.url = "github:nix-community/nixos-vscode-server";

    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland and friends #############
    #hyprland = {
    #  url = "https://github.com/hyprwm/Hyprland";
    #  type = "git";
    #  submodules = true;
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #hypridle = {
    #  url = "github:hyprwm/hyprlock";
    #  inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #    hyprutils.follows = "hyprland";
    #    hyprlang.follows = "hyprland";
    #  };
    #};

    #hyprlock = {
    #  url = "github:hyprwm/hyprlock";
    #  inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #    hyprutils.follows = "hyprland";
    #    hyprlang.follows = "hyprland";
    #  };
    #};

    #hyprpaper = {
    #  url = "github:hyprwm/hyprpaper";
    #  inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #    hyprutils.follows = "hyprland";
    #    hyprlang.follows = "hyprland";
    #    hyprwayland-scanner.follows = "hyprland";
    #  };
    #};

    #hy3 = {
    #  url = "github:outfoxxed/hy3";
    #  inputs.hyprland.follows = "hyprland";
    #};

    #hypr-dynamic-cursors = {
    #  url = "github:VirtCode/hypr-dynamic-cursors";
    #  inputs.hyprland.follows = "hyprland";
    #};

    ##hyprscroller = {
    #  url = "github:dawsers/hyprscroller";
    #  inputs.hyprland.follows = "hyprland";
    #};
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
