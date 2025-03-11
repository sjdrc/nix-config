{
  inputs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
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
}
