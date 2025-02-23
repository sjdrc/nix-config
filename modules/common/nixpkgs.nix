{inputs, ...}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (
      final: prev: let
        system = prev.stdenv.hostPlatform.system;
      in {
        openlens = inputs.nixpkgs-stable.legacyPackages.${system}.openlens;

        zen-browser = inputs.zen-browser.packages.${system}.default;
      }
    )
  ];
}
