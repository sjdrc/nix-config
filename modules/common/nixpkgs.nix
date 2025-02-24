{
  inputs,
  outputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (
      final: prev: let
        system = prev.stdenv.hostPlatform.system;
      in {
        zen-browser = inputs.zen-browser.packages.${system}.default;
        openlens = outputs.packages.openlens;
      }
    )
  ];
}
