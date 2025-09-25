{inputs, lib, ...}: {
  flake = {
    nixosModules.default = {...}: {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowBroken = true;

      nixpkgs.overlays = lib.mkForce [
        (
          final: prev: let
            system = prev.stdenv.hostPlatform.system;
          in {
            zen-browser = inputs.zen-browser.packages.${system}.default;
            openlens = inputs.blackai.packages.openlens;
          }
        )
      ];
    };
  };
}
